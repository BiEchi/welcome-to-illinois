//This state machine is used to provide stable signal.
module INPUTCONTROL(input logic Clk, Reset,
						  input logic [7:0] keycode,
						  output logic controlsignal);
				
enum logic[1:0]{START,END} State, Next_state;


always_ff @ (posedge Clk)
	begin
		if (Reset) 
			State <= START;
		else 
			State <= Next_state;
	end
	
always_comb
	begin
		Next_state=State;
		
		controlsignal=1'd0;
		unique case (State)
			START:
				begin
				if(keycode==8'h28)//enter
				begin
					Next_state=END;
				end
				end
			END:
				begin
				Next_state=END;
				end
			default:;
		endcase
		case (State)
			START:
				begin
				controlsignal=1'd0;
				end
			END:
				begin
				controlsignal=1'd1;
				end
			default:;
		endcase
	end
endmodule