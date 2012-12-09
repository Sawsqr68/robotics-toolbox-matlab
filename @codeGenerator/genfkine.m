function [t,allT] = genfkine(CGen)
%% GENFKINE Generates code from the symbolic robot specific forward kinematics expression.
%
%  Authors::
%        J�rn Malzahn
%        2012 RST, Technische Universit�t Dortmund, Germany
%        http://www.rst.e-technik.tu-dortmund.de
%

% Copyright (C) 1993-2012, by Peter I. Corke
%
% This file is part of The Robotics Toolbox for Matlab (RTB).
%
% RTB is free software: you can redistribute it and/or modify
% it under the terms of the GNU Lesser General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
%
% RTB is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU Lesser General Public License for more details.
%
% You should have received a copy of the GNU Leser General Public License
% along with RTB.  If not, see <http://www.gnu.org/licenses/>.
%
% http://www.petercorke.com


%% Derivation of symbolic expressions
CGen.logmsg([datestr(now),'\tDeriving forward kinematics ']);

q = CGen.rob.gencoords;
[t, allT] = CGen.rob.fkine(q);

CGen.logmsg('\t%s\n',' done!');

%% Save symbolic expressions
if CGen.saveresult
    CGen.logmsg([datestr(now),'\tSaving symbolic forward kinematics up to end-effector frame ']);
    
    CGen.savesym(t,'fkine','fkine.mat')
    
    CGen.logmsg('\t%s\n',' done!');
    
    CGen.logmsg([datestr(now),'\tSaving symbolic forward kinematics for joint: ']);
    
    for iJoint = 1:CGen.rob.n
        CGen.logmsg(' %s ',num2str(iJoint));
        tName = ['T0_',num2str(iJoint)];
        eval([tName,' = allT(:,:,',num2str(iJoint),');']);
        CGen.savesym(eval(tName),tName,[tName,'.mat']);
    end
    
    CGen.logmsg('\t%s\n',' done!');
end

%% M-Functions
if CGen.genmfun
    CGen.genmfunfkine;
end

%% Embedded Matlab Function Simulink blocks
if CGen.genslblock
    
    genslblockfkine(CGen);
    
end

end