// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2025 Advanced Micro Devices, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2025.1 (win64) Build 6140274 Thu May 22 00:12:29 MDT 2025
// Date        : Wed Sep  2 13:37:17 2026
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
