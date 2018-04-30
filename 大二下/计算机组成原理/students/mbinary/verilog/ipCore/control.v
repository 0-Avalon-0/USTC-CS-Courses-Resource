`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    18:26:36 04/11/2018 
// Design Name: 
// Module Name:    control 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module control(
	input clk,rst_n,
	//input [31:0] a,
	//input [31:0] b,
	input [31:0] aluout,
	output reg [5:0] ra=6'd0,//reg read addr
	input [31:0] rd,//reg read data
	output reg [5:0] wa=6'd0,
	output reg [31:0] wd,//reg write data
	output reg [31:0] td,//tmp data
	output reg ram_we,//reg write enable
	output reg [5:0] ram_ra,//reg read addr
	input [31:0] ram_rd//reg read data
    );
	reg [1:0] state=2'b11;//state�仯3->0->1->2->2->2...
	always@(negedge clk) //�½��ظı�����(reg��we��Ϊ1��ram��we�ڶ�a,b֮����)
		
		if(state==2'b11) 
			begin
				ram_ra<=6'b0;//��ram��a(��ram����ַΪ0����һ�������ؽ���ram[0]=a)
			end
		else if(state==2'b00) 
			begin
				wd<=ram_rd;//��regдa(��д���ݣ���һ�������ؽ�дreg[0]=a)
				ram_ra<=6'b1;//��ram��b(��ram����ַΪ1����һ�������ؽ���ram[1]=b)
			end
		else if(state==2'b01)
			begin
				wd<=ram_rd;//��regдb(��д���ݣ���һ�������ؽ�дreg[1]=b)
				td<=rd; //�Ĵ�ǰһ��rd
			end
		else if(state==2'b10) 
			begin	
				wd<=aluout;//��reg,ramдaluout(��д����Ϊaluout����һ�������ؽ�дreg,ram)
				td<=rd; //�Ĵ�ǰһ��rd
				ram_we=1'b1;//����ram��we��ram[2]��ʼд
			end
			
	always@(posedge clk or negedge rst_n) //�����ظı��ַ
	begin
		if(~rst_n)//��ʼ��
			begin
				wa<=6'd0;
				ra<=6'd0;
				state<=2'b11;
			end
		else
			begin
				if(state==2'b11)//���״̬��ֻ��ram������reg������
					begin
						state<=2'b00;
					end
				else if(state==2'b00)//дa״̬��reg����ַ��+1��ʹreg����ַ���regд��ַһ����
					begin
						state<=2'b01;
						wa<=wa+6'd1;
					end
				else if(state==2'b01)//дb״̬
					begin
						ra<=ra+6'd1;
						wa<=wa+6'd1;
						state<=2'b10;
					end
				else if(state==2'b10) //дaluout״̬
					begin
						ra<=ra+6'd1;
						wa<=wa+6'd1;
					end
				
			end
	end

endmodule
