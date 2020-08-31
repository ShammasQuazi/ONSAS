% Copyright (C) 2019, Jorge M. Perez Zerpa, J. Bruno Bazzano, Jean-Marc Battini, Joaquin Viera, Mauricio Vanzulli  
%
% This file is part of ONSAS.
%
% ONSAS is free software: you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
%
% ONSAS is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
%
% You should have received a copy of the GNU General Public License
% along with ONSAS.  If not, see <https://www.gnu.org/licenses/>.


function [ Fmasse, Me ] = elementTrussMassForce ( Xe, rho, A, booleanConsistentMassMat, ...
paramOut, Udotdotte )

  Xe = Xe(:) ;
  localAxisRef = Xe(4:6) - Xe(1:3) ;

  lini = sqrt( sum( localAxisRef.^2 ) ) ;

  Me = sparse( 12, 12 ) ;

  if booleanConsistentMassMat == 1
    Me (1:2:end, 1:2:end) = rho * A * lini * 2 / 6 * speye(6) ;
    
    Me (      1,       7) = rho * A * lini * 1 / 6            ;
    Me (      7,       1) = rho * A * lini * 1 / 6            ;
    
    Me (      3,       9) = rho * A * lini * 1 / 6            ;
    Me (      9,       3) = rho * A * lini * 1 / 6            ;
    
    Me (      5,      11) = rho * A * lini * 1 / 6            ;
    Me (     11,       5) = rho * A * lini * 1 / 6            ;
  else
    Me (1:2:end, 1:2:end) = rho * A * lini * 0.5 * eye(6) ;
  end
  
  Me = Me( 1:2:end, 1:2:end) ;
   
  Fmasse = Me * Udotdotte(1:2:end) ;
  
  
  
