function f = myBeam2HelicalLoadFunc(t)

global nLoadSteps targetLoadFactrForce targetLoadFactrMoment Nelem ;

vecLoadsForce = linspace(targetLoadFactrForce/nLoadSteps,targetLoadFactrForce,nLoadSteps);
[~,step] = ismembertol(t,vecLoadsForce);
f = zeros(6*(Nelem+1),1);
f(end) = targetLoadFactrMoment/nLoadSteps*step ;
    
% load Utp1

%   for i=1:Nelem+1
    nodeDofs         = nodes2dofs( i , 6 )       ;
    nodeAngDofs      = nodeDofs  ( 2:2:6 )       ;
  
%     TgNod            = Utp1 ( nodeAngDofs )      ;
%     TsMatrix         = Ts   ( TgNod )            ;
%    f(nodeAngDofs)   = TsMatrix' *f(nodeAngDofs) ;
%     f
%   end