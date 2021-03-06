% ---------------------------
% Toy Heat Transfer Problem
% ---------------------------

function aux_toyHeatTransferExample(caseNum, nelem, plotBoolean )

addpath('../sources/')

dt     = 0.001 ;
rho    = 1 ;
cSpHe  = 1 ;
kCond  = .5 ;
Ltot   = 1 ; % domain [0,1]
Area   = 1 ;

if nargin < 3
  plotBoolean = 1 ;
  if nargin < 2
    nelem = 10 ; 
  end
  close all
end

switch caseNum

case 1  % diri-diri conds

  Tfinal      = 0.1   ;
  diridofs    = [ 1 nelem+1 ] ;
  Tdiri       = 0 ;
  anlyBoolean = 1 ;   wx = 1 ;
  
case 2 % diri-hom-neum conds

  Tfinal   = .1   ;
  diridofs = [ 1 ] ;
  Tdiri    = 0    ;
  anlyBoolean = 1 ;  wx = .5 ;
  qentrDer       = 0 ;

case 3 % diri-nonhom neum conds

  Tfinal      = .02      ;
  diridofs    = [ 1 ] ;
  Tdiri       = 0       ;
  anlyBoolean = 0  ;
   wx = 1 ;
  qentrDer       = 2       ;

case 4 % diri-robin

  Tfinal      = .5      ;
  diridofs    = [ 1 ] ;
  Tdiri       = 0       ;
  anlyBoolean = 0       ;
  wx          = 1       ;
  Tamb        = .5       ;
  hConv  = 10 ;

case 5 % homneuman-robin

  Tfinal      = .1      ;
  diridofs    = [ ] ;
  anlyBoolean = 0       ;
  wx          = 1       ;
  Tamb        = .5       ;
  qentrIzq    = 1 ;
  hConv  = 10 ;

end



if exist('nt')==0
  nt     = Tfinal / dt ;
end

if exist('nCurves') == 0
  nCurves = 15 ;
end

alpha = kCond / ( rho * cSpHe ) ;

nnodes = nelem +1 ;

nnodesAnly = 100 ;

xs     = linspace(0, Ltot, nnodes     )' ;
xsAnly = linspace(0, Ltot, nnodesAnly )' ;


neumdofs = 1:nnodes ;
neumdofs( diridofs ) = [] ;

lelem  = Ltot/nelem ;

% local elemental diffussion equation
Kdiffe = kCond * Area / lelem * [ 1 -1 ; -1 1 ] ;

MintEe = rho * cSpHe * Area * lelem / 6 * [ 2 1 ; 1 2 ] ;

% initial temperature
T0     = sin(pi*xs*wx) + 0.5*sin(3*pi*xs*wx) ;
Ts     = T0 ;

   
% ------------------------
% matrices assembly
KdiffG = zeros( nnodes, nnodes ) ;
MintEG = zeros( nnodes, nnodes ) ;
MrobiG = zeros( nnodes, nnodes ) ;

for i = 1 : nelem
  nodeselem = [ i i+1 ] ;
  
  elemDofs = nodes2dofs ( nodeselem, 1 ) ;
  
  KdiffG( elemDofs , elemDofs ) = ...
  KdiffG( elemDofs , elemDofs ) + Kdiffe  ; 
  
  MintEG( elemDofs , elemDofs ) = ...
  MintEG( elemDofs , elemDofs ) + MintEe  ; 

end

if  exist( 'hConv') ~= 0
  MrobiG ( end,end) = hConv ;
end

KdiffG = KdiffG + MrobiG ;

% ------------------------

CDD = MintEG(diridofs, diridofs) ;
CND = MintEG(neumdofs, diridofs) ;
CNN = MintEG(neumdofs, neumdofs) ;

qext = zeros( nnodes, 1 ) ;
if exist( 'qentrIzq' ) ~= 0, qext(  1) = qentrIzq ; end
if exist( 'qentrDer' ) ~= 0, qext(end) = qentrDer ; end

if exist( 'Tamb' ) ~= 0 
  qext(end) = hConv * Tamb ;
end

if plotBoolean
  figure
  hold on, grid on
end

MS = 10 ; 
LW = 1.5 ; 

% ------------------------
% time loop
for i=0:nt
  t = i*dt ;
  
  if i~=0
    f = (    qext ( neumdofs    ) * dt ...
          - KdiffG( neumdofs, : ) * Ts( :, i ) * dt ...
          + MintEG( neumdofs, : ) * Ts( :, i ) 
        ) ;
        
    Ts( neumdofs, i+1 ) = CNN \ f ;
    if length(diridofs)>0,
      Ts( diridofs, i+1 ) = Tdiri   ;
    end
  end  

  if anlyBoolean
    if caseNum == 1 || caseNum == 2
      TsAnly (:,i+1) = exp(-(  pi* wx*alpha )^2 * t ) *       sin(     pi * xsAnly * wx ) ...
                     + exp(-(3*pi* wx*alpha )^2 * t ) * 0.5 * sin( 3 * pi * xsAnly * wx ) ;
    end
  end
  
  % --- plots ---
  if plotBoolean
  
    if mod(i, round(nt/nCurves) )==0
      plot( xs    , Ts    (:, i+1), 'b-o', 'markersize', MS,'linewidth',LW );  
      
      if anlyBoolean
        plot( xsAnly, TsAnly(:, i+1), 'r--'  , 'markersize', MS,'linewidth',LW );  
      end
    end
  end
    % ---------------
  
end
% ------------------------

if plotBoolean
  axis equal
  print( sprintf('../../1DheatCase_%1i.png', caseNum ),'-dpng'), close all

  %~ figure, plot( Ts(2,:) )
end

KdiffGNN = KdiffG(neumdofs, neumdofs ) ;

save -mat auxVars.mat KdiffGNN CNN Ts
