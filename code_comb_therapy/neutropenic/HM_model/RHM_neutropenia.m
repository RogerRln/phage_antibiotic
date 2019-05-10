% Code to simulate Phage-antibiotic combination therapy, heterogeneous mixing model (ODE)
% Neutropenic host 
% Inoculum: Phage-sensitive bacteria (BP)
% Phage and Antibiotic added two hours after infection
% Dependencies: (1) rhmODE.m (2) simRHM.m (3) myEventsFcn.m

clear
clc
close all

% Neutropenia parameters:
Ki = 2.4e7; % Maximum carrying capacity of immune response
Io = 0;     % Initial immune response
B = 7.4e7;  % Initial bacterial inoculum
P = 7.4e8;  % phage treatment
%P = 0; % no phage treatment

% Antibiotic parameters for Ciprofloxacin
dose = 0.014*2.5; % ug/ml, 2.5 x MIC of ciprofloxacin for BA strain
anti_name = 'CP';

                     
% Antibiotic parameters for Ceftazidime

%suggested_dosage = [0:10:600]*0.025;
%dose = suggested_dosage(7);
%dosing_interval = 1;
%anti_name = 'CAZ';


% Simulate phage-antibiotic combination therapy model in the absence of
% immune response against a phage-sensitive inoculum
[y, TB, time] = simRHM(Ki, Io, B, 0, P, dose, anti_name);

%----------------------------------------
% plotting
%----------------------------------------

% Do you want to show long run simulation (300 h)?
long_run = 0; % 1 for long run sim.

% Plot default values
set(0,'DefaultAxesLinewidth',2)
set(0, 'DefaultAxesFontName', 'Arial')

% Define color vectors
Bvector = [235 140 87]./255;
Rvector = [204 204 0]./255;
Pvector = [0 171 169]./255;
Ivector = [159 0 197]./255;
Avector = [0 0 0];
Kvector = [1 0 0];

figure(1)
semilogy(time, y(:,1),'Color', Bvector, 'Linewidth',3.5);
hold on;
semilogy(time, y(:,2),'Color', Rvector,'Linewidth',3.5)
semilogy(time, y(:,3),'LineStyle','--','Color', Pvector,'Linewidth',3.5)
%semilogy(time,y(:,4),'LineStyle','--','Color', Ivector,'Linewidth',2)
%semilogy(time(3:end), y(3:end, 5),'LineStyle','-','Color', Avector,'Linewidth',2)


%-----------------------------------------------------
xlabel('Hours post infection', 'FontSize', 16,'fontweight','bold')
if long_run
    set(gca,'XTick',[0:30:300])
else
    set(gca,'XTick',[0:12:96])
end
ylabel('Density (g^{-1})', 'FontSize', 16,'fontweight','bold')
h = findobj('Color',Bvector);
j = findobj('Color',Rvector);
g = findobj('Color',Pvector);
i = findobj('Color',Ivector);
d = findobj('Color', Avector);
k = findobj('Color', Kvector);

if P ~= 0
    % Legend for condition with phage treatment
    v = [g(1) h(1) j(1)]; 
    h_leg = legend(v, 'phage','BP','BA', 'Location','east');
else
    % Legend for condition with phage treatment
    v = [ h(1) j(1)];
    h_leg = legend(v, 'BP','BA', 'Location','east');
end

if long_run
    end_sim = 300;
else
    end_sim = 96;
end

if dose > 0 && dose <= 1
    axis([0,end_sim, 1, 1e13])
else
    axis([0,end_sim,1,1e13])
end

legend boxoff
set(gca,'FontSize',20,'fontweight','bold')
%set(gca, 'Units','inches','Position',[1 1 3 2.5])
set(h_leg, 'FontSize',20,'fontweight','normal')
set(gcf,'PaperPositionMode','manual','PaperPosition',[0.25 2.5 8 6],'PaperUnits','inches')
title({"Phages + Antibiotic against a B_{P} inoculum";"Heterogeneous mixing model"}, 'FontSize', 20)
