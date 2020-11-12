% ------------------------------------------------------------------------------ 
% ------      ONSAS example file: cantilever with nodal moment example    ------
% ------------------------------------------------------------------------------
clear all, close all
% --- ONSAS execution with aditive angles ---
auxUpdateAngles
angExponUpdate = 2;
run( [ pwd '/../ONSAS.m' ] ) ;
controlDispsAdditive = controlDisps ;


% --- ONSAS execution with exponential angles ---
auxUpdateAngles
angExponUpdate = 1;
run( [ pwd '/../ONSAS.m' ] ) ;
controlDispsExponential = controlDisps ;

%% Reduce 
        
%     controlDispsAdditive(1)=[];
%     controlDispsExponential(1)=[];
    loadFactors (1)=[]
    controlDispsAdditive(end)=[];
    controlDispsExponential(end)=[];
%% Ploteo 
close all
%Plot visual params
lw = 3.5; ms = 5; plotfontsize = 22 ;

figure
loadFactors = 0:targetLoadFactrMoment/nLoadSteps:targetLoadFactrMoment;
plot( loadFactors, analyticFunc(loadFactors) ,'b-' , 'linewidth', lw,'markersize',ms )
hold on, grid on

 plot( loadFactors, controlDispsAdditive ,'rx' , 'linewidth', lw,'markersize',14 )
plot( loadFactors, controlDispsExponential ,'co' , 'linewidth', lw,'markersize',ms )

legend ('AnalyticSol','AdditiveUpdate','ExponUpdate')
laby = ylabel('Disp_z (m)');   labx = xlabel('Moment_y (N.m)') ;
set(gca, 'linewidth', 1.2, 'fontsize', plotfontsize )
set(labx, 'FontSize', plotfontsize); set(laby, 'FontSize', plotfontsize) ;
axis ([4 150 -1.8 8])

txt = '\uparrow max=464';
text(120,3,txt)
fprintf ('%%%%%%%Valor maximo de desplazamiento:%%%%%%    ')
fprintf ('\n')
max(controlDispsAdditive)
fprintf ('%Divergation explote jj%\n')
figure
%  plot( matUs(end-2,:) ,'k' , 'linewidth', lw,'markersize',ms )




