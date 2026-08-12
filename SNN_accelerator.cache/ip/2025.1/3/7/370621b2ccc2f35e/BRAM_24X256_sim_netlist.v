// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2025 Advanced Micro Devices, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2025.1 (win64) Build 6140274 Thu May 22 00:12:29 MDT 2025
// Date        : Sun Aug  9 18:22:29 2026
// Host        : HUASHUO_U9_smm running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode funcsim -rename_top decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix -prefix
//               decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_ BRAM_24X256_sim_netlist.v
// Design      : BRAM_24X256
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xc7k70tfbv676-1
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CHECK_LICENSE_TYPE = "BRAM_24X256,blk_mem_gen_v8_4_11,{}" *) (* downgradeipidentifiedwarnings = "yes" *) (* x_core_info = "blk_mem_gen_v8_4_11,Vivado 2025.1" *) 
(* NotValidForBitStream *)
module decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix
   (clka,
    wea,
    addra,
    dina,
    clkb,
    addrb,
    doutb);
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA CLK" *) (* x_interface_mode = "slave BRAM_PORTA" *) (* x_interface_parameter = "XIL_INTERFACENAME BRAM_PORTA, MEM_ADDRESS_MODE BYTE_ADDRESS, MEM_SIZE 8192, MEM_WIDTH 32, MEM_ECC NONE, MASTER_TYPE OTHER, READ_LATENCY 1" *) input clka;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA WE" *) input [0:0]wea;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA ADDR" *) input [7:0]addra;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA DIN" *) input [23:0]dina;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTB CLK" *) (* x_interface_mode = "slave BRAM_PORTB" *) (* x_interface_parameter = "XIL_INTERFACENAME BRAM_PORTB, MEM_ADDRESS_MODE BYTE_ADDRESS, MEM_SIZE 8192, MEM_WIDTH 32, MEM_ECC NONE, MASTER_TYPE OTHER, READ_LATENCY 1" *) input clkb;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTB ADDR" *) input [7:0]addrb;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTB DOUT" *) output [23:0]doutb;

  wire [7:0]addra;
  wire [7:0]addrb;
  wire clka;
  wire clkb;
  wire [23:0]dina;
  wire [23:0]doutb;
  wire [0:0]wea;
  wire NLW_U0_dbiterr_UNCONNECTED;
  wire NLW_U0_rsta_busy_UNCONNECTED;
  wire NLW_U0_rstb_busy_UNCONNECTED;
  wire NLW_U0_s_axi_arready_UNCONNECTED;
  wire NLW_U0_s_axi_awready_UNCONNECTED;
  wire NLW_U0_s_axi_bvalid_UNCONNECTED;
  wire NLW_U0_s_axi_dbiterr_UNCONNECTED;
  wire NLW_U0_s_axi_rlast_UNCONNECTED;
  wire NLW_U0_s_axi_rvalid_UNCONNECTED;
  wire NLW_U0_s_axi_sbiterr_UNCONNECTED;
  wire NLW_U0_s_axi_wready_UNCONNECTED;
  wire NLW_U0_sbiterr_UNCONNECTED;
  wire [23:0]NLW_U0_douta_UNCONNECTED;
  wire [7:0]NLW_U0_rdaddrecc_UNCONNECTED;
  wire [3:0]NLW_U0_s_axi_bid_UNCONNECTED;
  wire [1:0]NLW_U0_s_axi_bresp_UNCONNECTED;
  wire [7:0]NLW_U0_s_axi_rdaddrecc_UNCONNECTED;
  wire [23:0]NLW_U0_s_axi_rdata_UNCONNECTED;
  wire [3:0]NLW_U0_s_axi_rid_UNCONNECTED;
  wire [1:0]NLW_U0_s_axi_rresp_UNCONNECTED;

  (* C_ADDRA_WIDTH = "8" *) 
  (* C_ADDRB_WIDTH = "8" *) 
  (* C_ALGORITHM = "1" *) 
  (* C_AXI_ID_WIDTH = "4" *) 
  (* C_AXI_SLAVE_TYPE = "0" *) 
  (* C_AXI_TYPE = "1" *) 
  (* C_BYTE_SIZE = "9" *) 
  (* C_COMMON_CLK = "0" *) 
  (* C_COUNT_18K_BRAM = "1" *) 
  (* C_COUNT_36K_BRAM = "0" *) 
  (* C_CTRL_ECC_ALGO = "NONE" *) 
  (* C_DEFAULT_DATA = "0" *) 
  (* C_DISABLE_WARN_BHV_COLL = "1" *) 
  (* C_DISABLE_WARN_BHV_RANGE = "0" *) 
  (* C_ELABORATION_DIR = "./" *) 
  (* C_ENABLE_32BIT_ADDRESS = "0" *) 
  (* C_EN_DEEPSLEEP_PIN = "0" *) 
  (* C_EN_ECC_PIPE = "0" *) 
  (* C_EN_RDADDRA_CHG = "0" *) 
  (* C_EN_RDADDRB_CHG = "0" *) 
  (* C_EN_SAFETY_CKT = "0" *) 
  (* C_EN_SHUTDOWN_PIN = "0" *) 
  (* C_EN_SLEEP_PIN = "0" *) 
  (* C_EST_POWER_SUMMARY = "Estimated Power for IP     :     3.35015 mW" *) 
  (* C_FAMILY = "kintex7" *) 
  (* C_HAS_AXI_ID = "0" *) 
  (* C_HAS_ENA = "0" *) 
  (* C_HAS_ENB = "0" *) 
  (* C_HAS_INJECTERR = "0" *) 
  (* C_HAS_MEM_OUTPUT_REGS_A = "0" *) 
  (* C_HAS_MEM_OUTPUT_REGS_B = "0" *) 
  (* C_HAS_MUX_OUTPUT_REGS_A = "0" *) 
  (* C_HAS_MUX_OUTPUT_REGS_B = "0" *) 
  (* C_HAS_REGCEA = "0" *) 
  (* C_HAS_REGCEB = "0" *) 
  (* C_HAS_RSTA = "0" *) 
  (* C_HAS_RSTB = "0" *) 
  (* C_HAS_SOFTECC_INPUT_REGS_A = "0" *) 
  (* C_HAS_SOFTECC_OUTPUT_REGS_B = "0" *) 
  (* C_INITA_VAL = "0" *) 
  (* C_INITB_VAL = "0" *) 
  (* C_INIT_FILE = "BRAM_24X256.mem" *) 
  (* C_INIT_FILE_NAME = "BRAM_24X256.mif" *) 
  (* C_INTERFACE_TYPE = "0" *) 
  (* C_LOAD_INIT_FILE = "1" *) 
  (* C_MEM_TYPE = "1" *) 
  (* C_MUX_PIPELINE_STAGES = "0" *) 
  (* C_PRIM_TYPE = "1" *) 
  (* C_READ_DEPTH_A = "256" *) 
  (* C_READ_DEPTH_B = "256" *) 
  (* C_READ_LATENCY_A = "1" *) 
  (* C_READ_LATENCY_B = "1" *) 
  (* C_READ_WIDTH_A = "24" *) 
  (* C_READ_WIDTH_B = "24" *) 
  (* C_RSTRAM_A = "0" *) 
  (* C_RSTRAM_B = "0" *) 
  (* C_RST_PRIORITY_A = "CE" *) 
  (* C_RST_PRIORITY_B = "CE" *) 
  (* C_SIM_COLLISION_CHECK = "ALL" *) 
  (* C_USE_BRAM_BLOCK = "0" *) 
  (* C_USE_BYTE_WEA = "0" *) 
  (* C_USE_BYTE_WEB = "0" *) 
  (* C_USE_DEFAULT_DATA = "0" *) 
  (* C_USE_ECC = "0" *) 
  (* C_USE_SOFTECC = "0" *) 
  (* C_USE_URAM = "0" *) 
  (* C_WEA_WIDTH = "1" *) 
  (* C_WEB_WIDTH = "1" *) 
  (* C_WRITE_DEPTH_A = "256" *) 
  (* C_WRITE_DEPTH_B = "256" *) 
  (* C_WRITE_MODE_A = "WRITE_FIRST" *) 
  (* C_WRITE_MODE_B = "WRITE_FIRST" *) 
  (* C_WRITE_WIDTH_A = "24" *) 
  (* C_WRITE_WIDTH_B = "24" *) 
  (* C_XDEVICEFAMILY = "kintex7" *) 
  (* downgradeipidentifiedwarnings = "yes" *) 
  (* is_du_within_envelope = "true" *) 
  decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_blk_mem_gen_v8_4_11 U0
       (.addra(addra),
        .addrb(addrb),
        .clka(clka),
        .clkb(clkb),
        .dbiterr(NLW_U0_dbiterr_UNCONNECTED),
        .deepsleep(1'b0),
        .dina(dina),
        .dinb({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .douta(NLW_U0_douta_UNCONNECTED[23:0]),
        .doutb(doutb),
        .eccpipece(1'b0),
        .ena(1'b0),
        .enb(1'b0),
        .injectdbiterr(1'b0),
        .injectsbiterr(1'b0),
        .rdaddrecc(NLW_U0_rdaddrecc_UNCONNECTED[7:0]),
        .regcea(1'b1),
        .regceb(1'b1),
        .rsta(1'b0),
        .rsta_busy(NLW_U0_rsta_busy_UNCONNECTED),
        .rstb(1'b0),
        .rstb_busy(NLW_U0_rstb_busy_UNCONNECTED),
        .s_aclk(1'b0),
        .s_aresetn(1'b0),
        .s_axi_araddr({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_arburst({1'b0,1'b0}),
        .s_axi_arid({1'b0,1'b0,1'b0,1'b0}),
        .s_axi_arlen({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_arready(NLW_U0_s_axi_arready_UNCONNECTED),
        .s_axi_arsize({1'b0,1'b0,1'b0}),
        .s_axi_arvalid(1'b0),
        .s_axi_awaddr({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_awburst({1'b0,1'b0}),
        .s_axi_awid({1'b0,1'b0,1'b0,1'b0}),
        .s_axi_awlen({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_awready(NLW_U0_s_axi_awready_UNCONNECTED),
        .s_axi_awsize({1'b0,1'b0,1'b0}),
        .s_axi_awvalid(1'b0),
        .s_axi_bid(NLW_U0_s_axi_bid_UNCONNECTED[3:0]),
        .s_axi_bready(1'b0),
        .s_axi_bresp(NLW_U0_s_axi_bresp_UNCONNECTED[1:0]),
        .s_axi_bvalid(NLW_U0_s_axi_bvalid_UNCONNECTED),
        .s_axi_dbiterr(NLW_U0_s_axi_dbiterr_UNCONNECTED),
        .s_axi_injectdbiterr(1'b0),
        .s_axi_injectsbiterr(1'b0),
        .s_axi_rdaddrecc(NLW_U0_s_axi_rdaddrecc_UNCONNECTED[7:0]),
        .s_axi_rdata(NLW_U0_s_axi_rdata_UNCONNECTED[23:0]),
        .s_axi_rid(NLW_U0_s_axi_rid_UNCONNECTED[3:0]),
        .s_axi_rlast(NLW_U0_s_axi_rlast_UNCONNECTED),
        .s_axi_rready(1'b0),
        .s_axi_rresp(NLW_U0_s_axi_rresp_UNCONNECTED[1:0]),
        .s_axi_rvalid(NLW_U0_s_axi_rvalid_UNCONNECTED),
        .s_axi_sbiterr(NLW_U0_s_axi_sbiterr_UNCONNECTED),
        .s_axi_wdata({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_wlast(1'b0),
        .s_axi_wready(NLW_U0_s_axi_wready_UNCONNECTED),
        .s_axi_wstrb(1'b0),
        .s_axi_wvalid(1'b0),
        .sbiterr(NLW_U0_sbiterr_UNCONNECTED),
        .shutdown(1'b0),
        .sleep(1'b0),
        .wea(wea),
        .web(1'b0));
endmodule
`pragma protect begin_protected
`pragma protect version = 1
`pragma protect encrypt_agent = "XILINX"
`pragma protect encrypt_agent_info = "Xilinx Encryption Tool 2025.1"
`pragma protect key_keyowner="Synopsys", key_keyname="SNPS-VCS-RSA-2", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=128)
`pragma protect key_block
gydSV72FvW4hnoyUt6yZFJHfJqjRQWPUfYIuDKP0fpjrPOkLRbJGBr4Z9msYTvoIHRlYtXJ2YMY0
d1TIQb+FK4gKsTRru9wr397OxuFBsTRf4e+ZjpYZEdsnqYWcgMSzhN4yhPvO06GyZO15y/LKBxa8
3OKwxVlOLYXhv+sxdXg=

`pragma protect key_keyowner="Aldec", key_keyname="ALDEC15_001", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
WHB6Zbfa5Qi47krP9T4L8UnPOlr881dWx7UcYaZfNGIQQM0gadcoXbhucIpRaUuyOKxv6yhKveRN
h0l+N9+KX6rbZ6+TRhP9JAMuPhlpI7T42QtRv5zx9+m3ct5S0NMszbFaK8zeTAYra5BGP7BHmtkr
MpKfLK5sFyaTE/A7ACtAace9MwFTHDZdl9uUs4aY6KJlm6GaypKduiqkNugukJp5vlFPX/ZapJqG
KMtMhI6grhcuYb1FJrwRZ4jW7hs9HxddSdGLzsZ0HsBcO/qaCPTst+ZA0YIQfd5ULlFmPqq39FfO
p1P+2hEH2n+LycbMj5cn4Dxfqv2R8eucM78R3w==

`pragma protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-VELOCE-RSA", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=128)
`pragma protect key_block
SmAzQA1VEuJXtJi5vXa2Jg7YvRqAJs6PX9HTZ1YqrJw4VfonBW3726gJ81BjlizpMkcf/Uk5sFIK
aPedVhEs4xCIZylz7gXYDshtytOA/pXUID2qV9nXr8qfI+FydSADUF3ScYDZmlkclFqlZrGq6DQ7
da3lJAzt2h/iR+cczrA=

`pragma protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-VERIF-SIM-RSA-2", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
iAph5JWb/chMQpLPX1UoLjQDxN5l2I8McM/k2xN5wRht7HXoE6F5yV8luDjn3zkI6vnfUYo7BaI1
mogRRx+R3XcwxvhHr+lngh4+/YLVex1TFncl+kiUMAsu3M/FjFSiqGMVMdKTNLDqr35DuZJVyuiF
lTwXob/KkbQDJiJjBEoxbt+968rKRKRyJGcqIjm4mqRBdqMcgo3HOJFG74SFsWAQrxvXfBhdLSG3
OfoLfls9XDojBjp7G83k0h82g1eeWgBfydm/OcX9o48Pst93NvI4ua8WShZL8MCvRWYqWZrrjrWi
cfUjXAF5SDACjq1/OU6arz/Idz6/a7AP/jmexw==

`pragma protect key_keyowner="Real Intent", key_keyname="RI-RSA-KEY-1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
BY49GZBxBT/gjZDPyaSWlti/sctckoR7jK6NuWdhnF9tiyNfVU7BqjjwxSnyMi0Uucv1BKHXC18h
8hQbFWnNtrq71ilURotXux7sssHlVJ2i1CsJWU18DOcBWxm2ai89uwvxDJh3TJkBJixB5KPvsDhL
lWOjTvZWPoR+Ixy+Tzo+U5Vx7z7SOakRwTrn3u7+c3vmCEBphE+HKeJExhBAoOEd0SXK5iwXaByW
D7Wb7zq6NNUmnCyaJ2BG9kGxLVsf+md7SlocuaFsYyaRZhwPyTucxIlz1tLYwcytKzx0ovoax3no
nYgzlzP/F0/PDWk9BqXgr/tuclc4EZYX0cf4ng==

`pragma protect key_keyowner="Xilinx", key_keyname="xilinxt_2025.1-2029.x", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
qGnCvL35qO7cbUEKCL50yDv1UvezcqBz601zctKop1954QlcjemzZWZHg1zJ00nJaToNdH2S8AKX
n8hNJvbQ+x5HEGL5DoSU9m5qjXd8xxocnZ0yzuZX/dGCT8kDn3gWJR2Gz13pT+w2LQUno1fX+MsC
ehgwvjBBT6GeYjdxHi+aybQUP9AblSxX/z3vh857SGCPohEWvghOgORCHAe45YD+ZWnL62FLxMM2
c+Ozq/Au/Q4q1Yzlzcfv8Mnsvg7OqOeEamQHbuYOfdkJUuYqOwsskEWW348u7FXtsf8m7P3pZyyz
IWyTDAW4igGguMPLHfbtK/twZx8ScJQmOKzglg==

`pragma protect key_keyowner="Metrics Technologies Inc.", key_keyname="DSim", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
Hz+6K8+wh5/fukU4ZWNDXGsq6hreSVCSPP67nA6kUz9Vpjy4TtTnOrrl1BWY0ivEC7Ldyw8VI60A
VO/WPlt409LdAZdMZGsEZ1JuTZ0m9LPcgu9CPCyoMECctmd8LHE+otY6etTmYABB9syY61rk2hrv
RgbcyT/HCK9TzWxSm+XMqvx2nvagCLkMDPh/JZv51fj2zcKaBPnxsz8rnDipaeo0fEyVRC3Y1F/V
U3RmXojBjIumPHSJkQ537dENJEIA0Ra65u8EM/+ItUn1bcryLcIbKy1xGadrHmHdHRUoRcAodO2C
B48bNVeL0VnGg8P9ACIB04lMNzn5p6A1tPOb4Q==

`pragma protect key_keyowner="Atrenta", key_keyname="ATR-SG-RSA-1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=384)
`pragma protect key_block
YDpb+UeT0rJ543Q8wCo2xSS3gpVAT+JoStgBlV5IMjJoUOWkiOPn691FGChmDi3BTq5NxC73KHHR
1galACCjeTGq6cv+0Zc2Ocm1oobdrnSPHp7TMDr5Zle8FX6WywJCiGdoWBODggZSlbOASIK/PVfY
cZM2z60M6RSvzsi3TnYHiKYHpju8THVoSgRd6r31GcbiSy9TjjARERXan0OVc79jGuAg90mmDEEq
91eqmn6NZ9yLI2fgBjFUZbtFCpmJ8WGxOL1h39niWnRK3ZXnk8jcpnZUlxLbYTPO0Z3vVr1zrvcn
RVQloU0OLqg7M95zSs7NtX5Vzvb6jGbMehWV+WMMyxWmxL2XOwsAwPSeX2dI2r77pioY7X6VzH7f
/JxMAnq9udra3WGPsUkD1G0CvPkCC3zdxjpVaflY37ztX9UONhKtzMQa8lJc1IL8GhXRY3R9Lg2c
HIeXSGkpNNuFDqKT6Khe/6Casq+SjFJq+IH9IUtz6RUZTkbFb0Xhgm2P

`pragma protect key_keyowner="Cadence Design Systems.", key_keyname="CDS_RSA_KEY_VER_1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
Q+63zFEYw/LeMgxa7g8g79GGvSyIKDKD8RvvC4DHDQuGObf6n9OGZX4e17v/E/+EDEwUhsWQHFDI
Lp/aH+6fNRmhu9BEWVjxq2WRrQSl4eQjfIaSOXu2dlYh3JjRJwiUp4LteVh8RFAf5t5sRQO4dRIK
x+h28yliSgibaWEAv5FaJQ1EFbNwmgedAaSYjgf2A3afBUcBh5Uy9VHbW/zRzdhhJdsVNBjZYcFy
CVLOcf1toCRp8J4U5FlnFMOzFegUbdXFQhq2VmIhPRxWjrfTk6iR4BcMEN9UMij/5IHRAeBdksyD
CqEKsyFxosbI5KVMRZ1Ln75Zipn0JdsGekHkxg==

`pragma protect key_keyowner="Synplicity", key_keyname="SYNP15_1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
DPUa5DLPYRWvbPnX0U412yoWvvvHyuq43DrYmDJGTK0cR5U4U6th8icYgizC1/hUAEzt19kM/hVa
zZh7bXSWACYLpcfhPY8dRTVGDZVjpbkraw0ceBryLP7jc6Jt5JdNw88tZtZpprCB7nQ25lUL82Hf
WTwL1ZqgGIvtfHhxO0JF5L5ES5giedwQ6u5ffXG3UB6ELcpQD1NvpW5lAz4mfXyvVDCAPZN581TF
tlAy79iKbPKlJ2zFn1BS2cuRIHHe2JRxwPo+0n5VD5CXVgg+lCYxTnCxI8CdyFaTumbs4IfAKwVI
wSN/btbwDUhW9hAHWHIRo+BpdJ4qeGcTDPKtsA==

`pragma protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-PREC-RSA", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
mf5hcf6JE6yLm0jNCQnHMVmogjLlPz6re0FwG67yvOJ3FuEorru0emIeAKEwgOoxjUYNWvcM7QAH
/UEeB2EIdjLl6glPAUda0HjtaCU2rdncVdM8k6DSMBggc4yo18Qx5F+1TD/RoBgoo0jNkMdDy6wJ
JHjqlN+R01z3yYIMQ9f2z6ZaYncbBYEp4+YAb7g1D7CSMxP5cFRpQznRpYp0JwqJfT9CHzlKgdab
8B288NxeLM66iYodiTS+GSRGLGtDWXpz9yeiuiPe6kJxae2GJyHIMSfluO/0Slc3m24DQNdbojf8
jdc0G2UnrDe5mCUTfYiDmpOWTUJOdYo0FK0N2g==

`pragma protect data_method = "AES128-CBC"
`pragma protect encoding = (enctype = "BASE64", line_length = 76, bytes = 20624)
`pragma protect data_block
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
`pragma protect end_protected
`ifndef GLBL
`define GLBL
`timescale  1 ps / 1 ps

module glbl ();

    parameter ROC_WIDTH = 100000;
    parameter TOC_WIDTH = 0;
    parameter GRES_WIDTH = 10000;
    parameter GRES_START = 10000;

//--------   STARTUP Globals --------------
    wire GSR;
    wire GTS;
    wire GWE;
    wire PRLD;
    wire GRESTORE;
    tri1 p_up_tmp;
    tri (weak1, strong0) PLL_LOCKG = p_up_tmp;

    wire PROGB_GLBL;
    wire CCLKO_GLBL;
    wire FCSBO_GLBL;
    wire [3:0] DO_GLBL;
    wire [3:0] DI_GLBL;
   
    reg GSR_int;
    reg GTS_int;
    reg PRLD_int;
    reg GRESTORE_int;

//--------   JTAG Globals --------------
    wire JTAG_TDO_GLBL;
    wire JTAG_TCK_GLBL;
    wire JTAG_TDI_GLBL;
    wire JTAG_TMS_GLBL;
    wire JTAG_TRST_GLBL;

    reg JTAG_CAPTURE_GLBL;
    reg JTAG_RESET_GLBL;
    reg JTAG_SHIFT_GLBL;
    reg JTAG_UPDATE_GLBL;
    reg JTAG_RUNTEST_GLBL;

    reg JTAG_SEL1_GLBL = 0;
    reg JTAG_SEL2_GLBL = 0 ;
    reg JTAG_SEL3_GLBL = 0;
    reg JTAG_SEL4_GLBL = 0;

    reg JTAG_USER_TDO1_GLBL = 1'bz;
    reg JTAG_USER_TDO2_GLBL = 1'bz;
    reg JTAG_USER_TDO3_GLBL = 1'bz;
    reg JTAG_USER_TDO4_GLBL = 1'bz;

    assign (strong1, weak0) GSR = GSR_int;
    assign (strong1, weak0) GTS = GTS_int;
    assign (weak1, weak0) PRLD = PRLD_int;
    assign (strong1, weak0) GRESTORE = GRESTORE_int;

    initial begin
	GSR_int = 1'b1;
	PRLD_int = 1'b1;
	#(ROC_WIDTH)
	GSR_int = 1'b0;
	PRLD_int = 1'b0;
    end

    initial begin
	GTS_int = 1'b1;
	#(TOC_WIDTH)
	GTS_int = 1'b0;
    end

    initial begin 
	GRESTORE_int = 1'b0;
	#(GRES_START);
	GRESTORE_int = 1'b1;
	#(GRES_WIDTH);
	GRESTORE_int = 1'b0;
    end

endmodule
`endif
