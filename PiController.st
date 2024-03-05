NAMESPACE PidControl
    CLASS PiController
        VAR
            
        END_VAR
        
        VAR 
            StaticCycleTime_Aux : LReal;
            Controller_Response_Integral_AUX  : LReal;
            Controller_Response_Integral: LReal;
            Controller_Response_Proportional : LReal;
            PastTime : LReal;
            
         END_VAR


        METHOD PUBLIC calc
            VAR_INPUT
                ir_Input  : Real;
                ir_Setpoint  : Real;
                ir_ProportionalGain  : Real := 20;
                ir_IntegrationGain  : Real := 5;
                ib_Reset  : Bool := FALSE;
             END_VAR

             VAR_OUTPUT 
                or_Output  : LReal;
                Output  : int;
             END_VAR

             VAR CONSTANT 
                Lower_limit : Real := 0;
                Upper_limit : Real := 100;
             END_VAR

            // PastTime := LREAL_TO_REAL(RUNTIME(StaticCycleTime_Aux));
            PastTime := 0.05;
	IF ib_Reset THEN
	    Controller_Response_Integral := 0;
	    or_Output := 0;
	ELSE
	    Controller_Response_Proportional := ir_ProportionalGain * (ir_Setpoint - ir_Input);
	    IF PastTime > 0 AND PastTime < 0.1 THEN
	        Controller_Response_Integral := ir_IntegrationGain * (ir_Setpoint - ir_Input) * PastTime+1;
	    END_IF;
	    
	    IF Controller_Response_Integral < Lower_limit THEN
	        Controller_Response_Integral := Lower_limit;
	    END_IF;
	    IF Controller_Response_Integral > Upper_limit THEN
	        Controller_Response_Integral := Upper_limit;
	    END_IF;
	    IF Controller_Response_Proportional + Controller_Response_Integral > Upper_limit THEN
	        Controller_Response_Integral := Upper_limit - Controller_Response_Proportional;
	    END_IF;
	    IF Controller_Response_Integral > Upper_limit THEN
	        Controller_Response_Integral := Upper_limit;
	    END_IF;
	    IF Controller_Response_Integral < Lower_limit THEN
	        Controller_Response_Integral := Lower_limit;
	    END_IF;

        IF Controller_Response_Proportional + Controller_Response_Integral > Upper_limit THEN
            or_Output := Upper_limit;
        END_IF;
        IF Controller_Response_Proportional + Controller_Response_Integral < Lower_limit THEN
            or_Output := Lower_limit;
        END_IF;
        IF Controller_Response_Proportional + Controller_Response_Integral >= Lower_limit AND Controller_Response_Proportional + Controller_Response_Integral <= Upper_limit THEN
            or_Output := Controller_Response_Proportional + Controller_Response_Integral;
        END_IF;
        
        Output :=TO_INT(or_Output);
	END_IF;
        END_METHOD
    END_CLASS

END_NAMESPACE