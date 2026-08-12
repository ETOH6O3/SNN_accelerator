// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2025 Advanced Micro Devices, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2025.1 (win64) Build 6140274 Thu May 22 00:12:29 MDT 2025
// Date        : Sun Aug  9 15:27:14 2026
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
  (* C_DISABLE_WARN_BHV_COLL = "0" *) 
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
