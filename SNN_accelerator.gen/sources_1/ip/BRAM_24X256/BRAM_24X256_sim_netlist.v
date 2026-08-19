// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2025 Advanced Micro Devices, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2025.1 (win64) Build 6140274 Thu May 22 00:12:29 MDT 2025
// Date        : Mon Aug 17 14:06:42 2026
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
  (* C_COMMON_CLK = "1" *) 
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
  (* C_SIM_COLLISION_CHECK = "NONE" *) 
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
  (* C_WRITE_MODE_B = "READ_FIRST" *) 
  (* C_WRITE_WIDTH_A = "24" *) 
  (* C_WRITE_WIDTH_B = "24" *) 
  (* C_XDEVICEFAMILY = "kintex7" *) 
  (* downgradeipidentifiedwarnings = "yes" *) 
  (* is_du_within_envelope = "true" *) 
  BRAM_24X256_blk_mem_gen_v8_4_11 U0
       (.addra(addra),
        .addrb(addrb),
        .clka(clka),
        .clkb(1'b0),
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
`pragma protect encoding = (enctype = "BASE64", line_length = 76, bytes = 20288)
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
