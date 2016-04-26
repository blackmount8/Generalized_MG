function MG = MG_dataSetting()
%% Variables indices:
%MG.UG_in, MG.UG_out, MG.UG_flg;
%MG.CL_in, MG.CL_out, MG.CL_flg;
%MG.ES_in, MG.ES_out, MG.ES_flg;
%MG.RE_in, (flg)
%MG.L0_out; (flg)
%MG.L1_out; (flg)
%MG.L2_out; (flg)
%MG.L2_ind_s; MG.L2_ind_e;
%% 
MG.horizon = 24;
%% Components
MG.numofUG = 1;	% Utility grid
MG.numofCL = 1; % Clutster of neighbourhood
MG.numofES = 1; % Energy storage
MG.numofEV = 0; % Electric Vehicle
MG.numofRE = 1; % Renewables
MG.numofL0 = 1; % Load type 0 (fixed load)
MG.numofL1 = 3; % Load type 1 (controllable and interruptible load) 
MG.numofL2 = 2; % Load type 2 (controllable and uninterruptible load)

MG.UG.name = {'Utility'};
MG.CL.name = {'Cluster1'};
MG.ES.name = {'ES1'};
MG.EV.name = {'EV1'};
MG.RE.name = {'PV'};
MG.L0.name = {'Base_Load'};
MG.L1.name = {'Dishwasher','Washing_Machine', 'Vacuum_Cleaner' };
MG.L2.name = {'L2_Device1', 'L2_Device2'};
MG.nameall = [MG.UG.name(1:MG.numofUG), MG.CL.name(1:MG.numofCL), MG.ES.name(1:MG.numofES), MG.EV.name(1:MG.numofEV), MG.RE.name(1:MG.numofRE), ...
    MG.L0.name(1:MG.numofL0), MG.L1.name(1:MG.numofL1), MG.L2.name(1:MG.numofL2) ];

%% Indicate the intcon:
MG.intcon = [ 
    MG.horizon*(2*MG.numofUG)+1:MG.horizon*(3*MG.numofUG), ... %UG
    MG.horizon*(3*MG.numofUG+2*MG.numofCL)+1:MG.horizon*(3*MG.numofUG+3*MG.numofCL), ... %CL
    MG.horizon*(3*MG.numofUG+3*MG.numofCL+2*MG.numofES)+1:MG.horizon*(3*MG.numofUG+3*MG.numofCL+3*MG.numofES), ... %ES
    MG.horizon*(3*MG.numofUG+3*MG.numofCL+3*MG.numofES+2*MG.numofEV)+1:MG.horizon*(3*MG.numofUG+3*MG.numofCL+3*MG.numofES+3*MG.numofEV), ... %EV
    MG.horizon*(3*MG.numofUG+3*MG.numofCL+3*MG.numofES+3*MG.numofEV)+1: ...
    MG.horizon*(3*MG.numofUG+3*MG.numofCL+3*MG.numofES+3*MG.numofEV+MG.numofRE+MG.numofL0+MG.numofL1+MG.numofL2)+ ...%RE,L0,L1,L2, and
    MG.numofL2*(MG.horizon+1) + MG.numofL2*(MG.horizon+1) ... %L2_s, L2_e
    ];
%% Constraint Variables
MG.A.all = [];
MG.b.all = [];
MG.Aeq.all = [];
MG.beq.all = [];
MG.lb = [];
MG.ub = [];
%% Data
MG = importData (MG, 'MG1.xlsx');


MG.CL.lb = [-1];
MG.CL.ub = [1];

MG.EV.lb = [-4];
MG.EV.ub = [4];

%Reshape the contraints
MG.UG.lb = reshape( repmat(MG.UG.lb(1:MG.numofUG), MG.horizon, 1), [], 1 );
MG.UG.ub = reshape( repmat(MG.UG.ub(1:MG.numofUG), MG.horizon, 1), [], 1 );
MG.CL.lb = reshape( repmat(MG.CL.lb(1:MG.numofCL), MG.horizon, 1), [], 1 );
MG.CL.ub = reshape( repmat(MG.CL.ub(1:MG.numofCL), MG.horizon, 1), [], 1 );
MG.ES.lb = reshape( repmat(MG.ES.lb(1:MG.numofES), MG.horizon, 1), [], 1 );
MG.ES.ub = reshape( repmat(MG.ES.ub(1:MG.numofES), MG.horizon, 1), [], 1 );
MG.EV.lb = reshape( repmat(MG.EV.lb(1:MG.numofEV), MG.horizon, 1), [], 1 );
MG.EV.ub = reshape( repmat(MG.EV.ub(1:MG.numofEV), MG.horizon, 1), [], 1 );

MG.ES.SOC_0 = MG.ES.SOC_0.*MG.ES.cap;
MG.ES.SOC_max = MG.ES.SOC_max.*MG.ES.cap;
MG.ES.SOC_min = MG.ES.SOC_min.*MG.ES.cap;
end
