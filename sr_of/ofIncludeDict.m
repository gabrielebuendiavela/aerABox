% This function aims to write the includeDict file containing some
% variables relevant for the boundary conditions in OpenFOAM configuration
% files
%       Author  : Gabriel Buendia
%       Version : 1
% Inputs:
%       path     -> Path to save the file locally
%       Reynolds -> Reynolds number
%       AoA      -> Angle of attack [º]
%       nu       -> Dynamic viscosity of the freestream [m^2/s]
%       nut      -> Turbulent viscosity boundaries [m^2/s]
%       p        -> Pressure of the freestream [Pa]
%       rho      -> Density of the freestream [kg/m^3]
%       I        -> Turbulent intensity (0->0%, 1->100%)
%       e        -> Eddy viscosity ratio
%       l        -> Characteristic length [m]
%       vel      -> Flight speed [m/s]
function ofIncludeDict(path,Reynolds,AoA,nu,nut,p,rho,I,e,l,vel) 
fileName = fopen(append(path,'includeDict'),'w');
string = append(['/','*--------------------------------*- C++ -*----------------------------------*','\\',' \n' ...
                '| =========                 |                                                 | \n' ...
                '| \\\\      /  F ield         | OpenFOAM: The Open Source CFD Toolbox           | \n' ...
                '|  \\\\    /   O peration     | Version:  dev                                   | \n' ...
                '|   \\\\  /    A nd           | Web:      www.OpenFOAM.org                      | \n' ...
                '|    \\\\/     M anipulation  |                                                 | \n' ...
                '\\','*---------------------------------------------------------------------------*','/',' \n\n' ...
                '// Input parameters:\n' ...
                'turbulence_model    kOmegaSST;\n' ...
                'Re                  ',num2str(Reynolds),';\n' ...
                'alpha               ',num2str(AoA),';\n' ...
                'nu_s				',num2str(nu),';\n' ...
                'nut                 ',num2str(nut),';\n' ...
                'p 					',num2str(p),';\n' ...
                'rho_s               ',num2str(rho),';\n' ...
                'p_rho				#calc "$p/$rho_s";\n' ...
                'I                   ',num2str(I),'; // Turbulence intensity\n' ...
                'b                   ',num2str(e),'; // Eddy viscosity ratio\n' ...
                'l                   ',num2str(l),'; // Characteristic length\n' ...
                'vel                 ',num2str(vel),';  // Speed\n' ...
                '// Calculate the boundary conditions from the input parameters\n' ...
                'alphar              #calc "degToRad($alpha)";\n' ...
                'i                   #calc "$vel*cos(double($alphar))";\n' ...
                'j                   0;\n' ...
                'k                   #calc "$vel*sin(double($alphar))";\n' ...
                'mk                  #calc "-($k)";\n\n\n' ...
                'Ui                  ($i $j $k);\n' ...
                'nui                 #calc "$vel*$l/$Re";\n' ...
                'ki                  #calc "3./2. * pow($vel*$I,2.0)";\n' ...
                'omegai              #calc "$ki/$b/$nui";']);
fprintf(fileName,string);
fclose(fileName);
end