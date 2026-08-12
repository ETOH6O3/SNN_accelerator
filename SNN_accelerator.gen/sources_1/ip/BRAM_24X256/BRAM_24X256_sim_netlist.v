// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2025 Advanced Micro Devices, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2025.1 (win64) Build 6140274 Thu May 22 00:12:29 MDT 2025
// Date        : Sun Aug  9 18:22:30 2026
// Host        : HUASHUO_U9_smm running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode funcsim
//               c:/MARTIN/verilog/Xilinx/projects_vivado/SNN_accelerator/SNN_accelerator.gen/sources_1/ip/BRAM_24X256/BRAM_24X256_sim_netlist.v
// Design      : BRAM_24X256
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xc7k70tfbv676-1
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CHECK_LICENSE_TYPE = "BRAM_24X256,blk_mem_gen_v8_4_11,{}" *) (* downgradeipidentifiedwarnings = "yes" *) (* x_core_info = "blk_mem_gen_v8_4_11,Vivado 2025.1" *) 
(* NotValidForBitStream *)
module BRAM_24X256
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
  BRAM_24X256_blk_mem_gen_v8_4_11 U0
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
`pragma protect encoding = (enctype = "BASE64", line_length = 76, bytes = 20592)
`pragma protect data_block
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
j2xNvxHmyeDwH0QIwL4J
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
