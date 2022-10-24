`default_nettype none
`timescale 1ns / 1ps

module ether(
	input wire clk,
	input wire rst,
	input wire [1:0] rxd,
	input wire crsdv,

	output logic axiov,
	output logic [1:0] axiod
);


`default_nettype wire
