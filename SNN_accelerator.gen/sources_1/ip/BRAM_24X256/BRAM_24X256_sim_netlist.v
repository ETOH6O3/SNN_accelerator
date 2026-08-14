// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2025 Advanced Micro Devices, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2025.1 (win64) Build 6140274 Thu May 22 00:12:29 MDT 2025
// Date        : Wed Aug 12 23:31:31 2026
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
JsKezopI8B1oDGy4hatv
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
