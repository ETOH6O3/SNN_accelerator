
package poisson;

  // NOTE: 来自 gen_spikes.cpp 的函数
  import "DPI-C" function void next(inout byte unsigned img[][][]);
  import "DPI-C" function void report_queue();
  import "DPI-C" function void resume_breakpoint(longint unsigned last_idx);

  class PoissonImg #(
      parameter longint unsigned _T = 250,
      parameter longint unsigned _H = 16,
      parameter longint unsigned _W = 16
  );
    longint unsigned __timestep;
    typedef byte unsigned __Imgs[_T][_H][_W];
    __Imgs __imgs;
    typedef type (__imgs[0]) __Img;

    virtual aer_if.source __aer_tx;
    logic __tclk;


    function new(virtual aer_if aer);
      this.__timestep = 0;
      this.bind_aer_if(aer);
      this.__aer_tx.req = 0;
      this.next();  // 拿到第一系列图片
    endfunction

    local task automatic start_tclk(input time half_period);
      this.__tclk = 0;
      fork
        forever begin
          #half_period this.__tclk = !this.__tclk;
        end
      join_none
    endtask

    local function automatic void next();
      poisson::next(__imgs);
      this.__timestep = 0;
    endfunction

    local function automatic void bind_aer_if(virtual aer_if aer);
      this.__aer_tx = aer;
    endfunction

    local task automatic send_img();
      $display("[PoissonImg] @%0t: Sending image at timestep %0d", $time, __timestep);
      if (__timestep % 10 == 0) begin
        for (int i = 0; i < _H; i++) begin
          for (int j = 0; j < _W; j++) begin
            $write("%s", __imgs[__timestep][i][j] == 0 ? "  " : "@@");
          end
          $display("");
        end
      end
      for (int i = 0; i < _H; i++) begin
        for (int j = 0; j < _W; j++) begin
          if (__imgs[__timestep][i][j] != 0) begin
            wait (this.__aer_tx.ack == 0);
            @(negedge this.__tclk);
            this.__aer_tx.addr <= {1'b1, __timestep[0], i[3:0], j[3:0]};
            #1 this.__aer_tx.req <= 1;
            wait (this.__aer_tx.ack == 1);
            @(negedge this.__tclk);
            this.__aer_tx.req <= 0;
          end
        end
      end
    endtask

    task automatic send_imgs(input time half_period, input longint unsigned start_idx = 0);
      start_tclk(half_period);
      forever begin
        for (this.__timestep = 0; this.__timestep < _T; this.__timestep++) begin
          send_img();
        end
        report_queue();
        this.next();
        report_queue();
      end
    endtask  //automatic

  endclass

endpackage : poisson

