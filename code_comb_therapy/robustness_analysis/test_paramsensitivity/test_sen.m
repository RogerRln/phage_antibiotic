clear
clc
close all

% Immunocompetence parameters:

Ki = 2.4e7; % maximum capacity of immune response
Io = 2.7e6; % Initial immune response
Phage = 7.4e8; % phage treatment

% Constructing a vector with fold change values of MIC (from 0
% to 10 X MIC)

MIC = 0.014;  % ug/ml, MIC of ciprofloxacin for antibiotic-sensitive strain (BA)
up_MIC_10 = [10:-0.5:1.5]; % from 1.5 MIC to 10 MIC
sub_MIC_0= [1:-.05:0.1]; % from 0.1 MIC to 1 MIC
anti_conc = [up_MIC_10 sub_MIC_0];

% Vector containing variations in inoculum proportions (from 0% BA to 100% BA)
B_total = 7.4e7;
Bp_proportions = [1:-0.05:0];

% Total number of 96hrs simulations, one simulation for each pair of modified initial conditions fold-change MIC & Inoculum
% proportion
tot = length(anti_conc)*length(Bp_proportions);


sim = 1000; % Total number of simulations, one simulation per modified parameter set
% vectors to keep track of param values
r_vec = zeros(sim, 1);
rp_vec = zeros(sim, 1);
Kc_vec = zeros(sim, 1);
phi_vec = zeros(sim, 1);
g_vec = zeros(sim, 1);
ep_vec = zeros(sim, 1);
Kd_vec = zeros(sim, 1);
beta_vec = zeros(sim, 1);
w_vec = zeros(sim, 1);
a_vec = zeros(sim, 1);
Ki_vec = zeros(sim, 1);
Kn_vec = zeros(sim, 1);
m_vec = zeros(sim, 1);
m2_vec = zeros(sim, 1);
kkill_vec = zeros(sim, 1);
ec_vec = zeros(sim, 1);
H_vec = zeros(sim, 1);
theta_vec = zeros(sim, 1);


% vectors to save percentage of simulation that end in bact. extinction for
% A + P + I therapeutic
extinction_vec = zeros(1,sim);
perc_extinction_vec = zeros(1,sim);

% vectors to save percentage of simulation that end in bact. extinction for
% A + P  therapeutic
extinction_vec_ap = zeros(1,sim);
perc_extinction_vec_ap = zeros(1,sim);


tic
for ind = 1:sim %sim
    
    if ind == 1
        % susceptible bacteria growth rate
        p.r = 0.75;
        r_vec(ind) = p.r;
        % resistant bacteria growth rate
        p.rp = 0.675;
        rp_vec(ind) = p.rp;
        % total bacteria carrying capacity
        p.Kc = 1e10;
        Kc_vec(ind) = p.Kc;
        % nonlinear adsorption rate of phage:
        p.phi = 5.4e-8;
        phi_vec(ind) = p.phi;
        % power law exponent in phage infection:
        p.g = 0.6;
        g_vec(ind) = p.g;
        % immune response killing rate parameter:
        p.ep = 8.2e-8;
        ep_vec(ind) = p.ep;
        % bacterial conc. at which immune response is half as effective:
        p.Kd = 4.1e7;
        Kd_vec(ind) = p.Kd;
        % burst size of phage:
        p.beta = 100;
        beta_vec(ind) = p.beta;
        % decay rate of phage:
        p.w = 0.07;
        w_vec(ind) = p.w;
        % maximum growth rate of immune response:
        p.a = 0.97;
        a_vec(ind) = p.a;
        % max capacity of immune response:
        p.Ki = Ki;
        Ki_vec(ind) = p.Ki;
        % conc. of bacteria at which imm resp growth rate is half its maximum:
        p.Kn = 1e7;
        Kn_vec(ind) = p.Kn;
        % probability of emergence of phage-resistant mutation per cell division
        p.m = 2.85e-8; %
        m_vec(ind) = p.m;
        % probability of reversible mutation probability (Phage resistant -> Phage sensitive)
        p.m2 = 2.85e-8;
        m2_vec(ind) = p.m2;

        % Maximum antibiotic-mediated kill rate
        p.kkill = 18.5;
        kkill_vec(ind) = p.kkill;
        % EC_50, antibiotic concentration when kkill/2
        p.ec = 0.3697;
        ec_vec(ind) = p.ec;
        % Steepness of the sigmoid relationship between Antibiotic and death
        % rate
        p.H = 1;
        H_vec(ind) = p.H;
        % Elimination rate of antibiotic from blood
        p.theta = 0.53;
        theta_vec(ind) = p.theta;
   
    else
        
        % original param. values can vary within (+-)10% of their original value

        % phage-susceptible bacteria growth rate
        p.r = 0.75 * (1 + .2*rand(1,1) - .1); 
        r_vec(ind) = p.r;
        % antibiotic-sensitive bacteria growth rate
        p.rp = 0.675 * (1 + .2*rand(1,1) - .1);
        rp_vec(ind) = p.rp;
        % total bacteria carrying capacity
        p.Kc = 1e10 * (1 + .2*rand(1,1) - .1);
        Kc_vec(ind) = p.Kc;
        % nonlinear adsorption rate of phage:
        p.phi = 5.4e-8 * (1 + .2*rand(1,1) - .1);
        phi_vec(ind) = p.phi;
        % power law exponent in phage infection:
        p.g = 0.6 * (1 + .2*rand(1,1) - .1);
        g_vec(ind) = p.g;
        % immune response killing rate parameter:
        p.ep = 8.2e-8 * (1 + .2*rand(1,1) - .1);
        ep_vec(ind) = p.ep;
        % bacterial conc. at which immune response is half as effective:
        p.Kd = 4.1e7 * (1 + .2*rand(1,1) - .1);
        Kd_vec(ind) = p.Kd;
        % burst size of phage:
        p.beta = 100 * (1 + .2*rand(1,1) - .1);
        beta_vec(ind) = p.beta;
        % decay rate of phage:
        p.w = 0.07 * (1 + .2*rand(1,1) - .1);
        w_vec(ind) = p.w;
        % maximum growth rate of immune response:
        p.a = 0.97 * (1 + .2*rand(1,1) - .1);
        a_vec(ind) = p.a;
        % max capacity of immune response:
        p.Ki = Ki * (1 + .2*rand(1,1) - .1);
        Ki_vec(ind) = p.Ki;
        % conc. of bacteria at which imm resp growth rate is half its maximum:
        p.Kn = 1e7 * (1 + .2*rand(1,1) - .1);
        Kn_vec(ind) = p.Kn;
        % probability of emergence of phage-resistant mutation per cell division
        p.m = 2.85e-8 * (1 + .2*rand(1,1) - .1);
        m_vec(ind) = p.m;
        % probability of reversible mutation probability (Phage resistant -> Phage sensitive)
        p.m2 = 2.85e-8 * (1 + .2*rand(1,1) - .1);
        m2_vec(ind) = p.m2;


        % Maximum antibiotic-mediated kill rate
        p.kkill = 18.5 * (1 + .2*rand(1,1) - .1);
        kkill_vec(ind) = p.kkill;
        % EC_50, antibiotic concentration when kkill/2
        p.ec = 0.3697 * (1 + .2*rand(1,1) - .1);
        ec_vec(ind) = p.ec;
        % Steepness of the sigmoid relationship between Antibiotic and death
        % rate
        p.H = 1 * (1 + .2*rand(1,1) - .1);
        H_vec(ind) = p.H;
        % Elimination rate of antibiotic from blood
        p.theta = 0.53 * (1 + .2*rand(1,1) - .1);
        theta_vec(ind) = p.theta;
    end



% Antibiotic pulse such that the Antibiotic conc. is at equilibrium
% A = I - theta*A
% A_star = I/theta
% I = A_star*theta
p.pulse = 0 * p.theta;  % we're gonna keep this varying as usual with the concent. of antibiotic and with theta, i.e., coupled params


matrix = zeros(length(anti_conc), length(Bp_proportions));
matrix_threshold = zeros(length(anti_conc), length(Bp_proportions));
time_v = [];
for i = 1:length(anti_conc)
        anti_dose = anti_conc(i)*MIC;
        
        for j = 1:length(Bp_proportions)
            proportion = Bp_proportions(j);
            
            Bp = B_total * proportion;
            Ba = B_total - Bp;
            [y, TB, time] = simRHM_WT_sensitivity(Ki, Io, Bp, Ba, Phage, anti_dose, p);
            time_v = [time_v time(end)];
            Bp_steady = y(end, 1);
            Ba_steady = y(end, 2);
            Btotal_steady = Bp_steady + Ba_steady;
            matrix(i,j) = Btotal_steady;
            if Ba_steady > Bp_steady
                ba = 1;
            else
                ba = 0;
            end
            matrix_threshold(i,j) = ba;
            
        end
end

matrix_ap = zeros(length(anti_conc), length(Bp_proportions));
matrix_threshold_ap = zeros(length(anti_conc), length(Bp_proportions));
time_v_ap = [];

for i = 1:length(anti_conc)
        anti_dose = anti_conc(i)*MIC;
        
        for j = 1:length(Bp_proportions)
            proportion = Bp_proportions(j);
            
            Bp = B_total * proportion;
            Ba = B_total - Bp;
            [y, TB, time] = simRHM_WT_sensitivity(Ki, 0, Bp, Ba, Phage, anti_dose, p);
            time_v_ap = [time_v_ap time(end)];
            Bp_steady = y(end, 1);
            Ba_steady = y(end, 2);
            Btotal_steady = Bp_steady + Ba_steady;
            matrix_ap(i,j) = Btotal_steady;
            if Bp_steady > Ba_steady
                 bp = 1;
            else
                 bp = 0;
            end
            matrix_threshold_ap(i,j) = bp;
            
        end
end

% Threshold results
thresh_api(ind).mat_thresh = matrix_threshold;
thresh_ap(ind).mat_thresh = matrix_threshold_ap;

% save results of A + P + I simulations
Results(ind).mat_api = matrix;
Results(ind).time_api = time_v;

% save results of A + P simulations
Results(ind).mat_ap = matrix_ap;
Results(ind).time_ap = time_v_ap;

% Extract number of simulations where bact. populations are driven to
% extinction for A + P + I therapeutic
num_extinct = sum(matrix(:) == 0);
perc_extinct = num_extinct/tot;

extinction_vec(ind) = num_extinct;
perc_extinction_vec(ind) = perc_extinct;


% Extract number of simulations where bact. populations are driven to
% extinction for A + P  therapeutic
num_extinct_ap = sum(matrix_ap(:) == 0);
perc_extinct_ap = num_extinct_ap/tot;

extinction_vec_ap(ind) = num_extinct_ap;
perc_extinction_vec_ap(ind) = perc_extinct_ap;


end
toc

% Save results
save ('/Users/rrodriguez77/Dropbox (GaTech)/Combination_therapy_paperrevision/code_081419/code_comb_therapy/robustness_analysis/thresh_api_test.mat', 'thresh_api')
save ('/Users/rrodriguez77/Dropbox (GaTech)/Combination_therapy_paperrevision/code_081419/code_comb_therapy/robustness_analysis/thresh_ap_test.mat', 'thresh_ap')

save ('/Users/rrodriguez77/Dropbox (GaTech)/Combination_therapy_paperrevision/code_081419/code_comb_therapy/robustness_analysis/Results_test.mat', 'Results')


save ('/Users/rrodriguez77/Dropbox (GaTech)/Combination_therapy_paperrevision/code_081419/code_comb_therapy/robustness_analysis/extinction_vec_test.mat', 'extinction_vec')
save ('/Users/rrodriguez77/Dropbox (GaTech)/Combination_therapy_paperrevision/code_081419/code_comb_therapy/robustness_analysis/perc_extinction_vec_test.mat', 'perc_extinction_vec')


save ('/Users/rrodriguez77/Dropbox (GaTech)/Combination_therapy_paperrevision/code_081419/code_comb_therapy/robustness_analysis/extinction_vec_ap_test.mat', 'extinction_vec_ap')
save ('/Users/rrodriguez77/Dropbox (GaTech)/Combination_therapy_paperrevision/code_081419/code_comb_therapy/robustness_analysis/perc_extinction_vec_ap_test.mat', 'perc_extinction_vec_ap')


% visualize distrubution of fraction of simulations in which bacteria
% go to extinction
figure(1)
map = colormap(lines(2)); 
histogram(perc_extinction_vec, 10, 'facecolor',map(1,:),'facealpha',.5)
hold on
histogram(perc_extinction_vec_ap, 10, 'facecolor',map(2,:),'facealpha',.5)
%box off
axis tight
legend('A + P + I', 'A + P','location','northeast')
legend boxoff

all_paramval = [r_vec rp_vec Kc_vec phi_vec g_vec ep_vec Kd_vec beta_vec w_vec a_vec Ki_vec Kn_vec m_vec m2_vec kkill_vec ec_vec H_vec theta_vec];


% figure(2)
% % Visualize the heatmaps
% for indice = 1:5
% 
%     %fig = figure(1);
%     subplot(4, 4, indice);
%     cmap = colormap(parula(100));
%     cmap = [1, 1, 1; cmap];
%     matrix = Results(indice).mat_api;
%     matrix(find(matrix <= 1)) = 1;
%     matrix = log10(matrix);
%     imagesc(matrix);
%     colormap(cmap);
%     hold on
%     h = colorbar;
%     caxis([0 10])
%     
%     ylabel(h, 'Bacterial density (g^{-1})', 'FontSize', 16, 'fontweight', 'bold')
%     title(h, 'log10 (B)', 'FontSize', 16, 'fontweight', 'bold')
%     xlim = get(gca, 'Xlim');
%     plot(xlim, [19 19], '--k', 'Linewidth', 2 )
%     hold off
% 
%     xlabel('B_{A} inoculum proportion','FontSize',20)
%     ylabel('Fold Change in MIC','FontSize',20, 'Position', [-1.8 19])
%     set(gca,'XTick',[1:10:21])
%     xt = get(gca, 'XTick');
%     set(gca, 'XTick', xt, 'XTickLabel',[0:0.5:1], 'FontSize', 16)
% 
% 
%     concentrations = sort(anti_conc, 'descend');
%     set(gca,'YTick', [1:18:37], 'yticklabel',[],'ytickmode','manual');
%     yt = get(gca, 'YTick');
%     for j=1:length(yt)
%       h=text(-.8 , yt(j), ['10^{' num2str(log10( concentrations(yt(j)))) '}']);
%       set(h,'HorizontalAlignment','center','fontsize',get(gca,'fontsize'),'fontweight', 'bold')
%     end
%     set(gca, 'fontweight', 'bold')
%     if indice == 1
%         title('\theta_{reference}', 'FontSize', 20)
%     else
%         title(['\theta_{' int2str(indice) '}'], 'FontSize', 20)
%     end
%     
%     matrix_threshold = thresh_api(indice).mat_thresh;
%     s = size(matrix_threshold);
%     ncol = s(2);
%     threshold = [];
%     for i = 1:ncol
%         ind = find(matrix_threshold(:,i) == 1);
%         if isempty(ind)
%             ind = [38];
%         end
%         threshold = [threshold ind(1)];
%     end
%     hold on
%     plot([0:22], [threshold(1) threshold threshold(end)], '-k', 'Linewidth', 3 )
%     hold off
%     
%     if Results(indice).mat_api(10, 10) ~= 0
%         bp_text=text(10 , 12, 'B_P', 'fontsize',  16,'fontweight', 'bold');
%     end
%         ba_text=text(10 , 34, 'B_A','fontsize', 16,'fontweight', 'bold' );
%     
%     axis square
% end
% sgtitle('A + P + I outcomes for different parameter sets', 'fontsize', 18, 'fontweight', 'bold')
% 
% figure(3)
% % Visualize the heatmaps
% for indice = 1:16
% 
%     %fig = figure(1);
%     subplot(4, 4, indice);
%     cmap = colormap(parula(100));
%     cmap = [1, 1, 1; cmap];
%     matrix = Results(indice).mat_ap;
%     matrix(find(matrix <= 1)) = 1;
%     matrix = log10(matrix);
%     imagesc(matrix);
%     colormap(cmap);
%     hold on
%     h = colorbar;
%     caxis([0 10])
%     
%     ylabel(h, 'Bacterial density (g^{-1})', 'FontSize', 16, 'fontweight', 'bold')
%     title(h, 'log10 (B)', 'FontSize', 16, 'fontweight', 'bold')
%     xlim = get(gca, 'Xlim');
%     plot(xlim, [19 19], '--k', 'Linewidth', 2 )
%     hold off
% 
%     xlabel('B_{A} inoculum proportion','FontSize',20)
%     ylabel('Fold Change in MIC','FontSize',20, 'Position', [-1.8 19])
%     set(gca,'XTick',[1:10:21])
%     xt = get(gca, 'XTick');
%     set(gca, 'XTick', xt, 'XTickLabel',[0:0.5:1], 'FontSize', 16)
% 
% 
%     concentrations = sort(anti_conc, 'descend');
%     set(gca,'YTick', [1:18:37], 'yticklabel',[],'ytickmode','manual');
%     yt = get(gca, 'YTick');
%     for j=1:length(yt)
%       h=text(-.8 , yt(j), ['10^{' num2str(log10( concentrations(yt(j)))) '}']);
%       set(h,'HorizontalAlignment','center','fontsize',get(gca,'fontsize'),'fontweight', 'bold')
%     end
%     set(gca, 'fontweight', 'bold')
%     
%     if indice == 1
%         title('\theta_{reference}', 'FontSize', 20)
%     else
%         title(['\theta_{' int2str(indice) '}'], 'FontSize', 20)
%     end
%     
%     matrix_threshold = thresh_ap(indice).mat_thresh;
%     s = size(matrix_threshold);
%     ncol = s(2);
%     threshold = [];
%     for i = 1:ncol
%         ind = find(matrix_threshold(:,i) == 1);
%         if ind(end) == 37
%            ind(end) = 38;
%         end
%         threshold = [threshold ind(end)];
%     end
%     hold on
%     plot([0:22], [threshold(1) threshold threshold(end)], '-k', 'Linewidth', 3 )
%     hold off
%     
%     if matrix_threshold(10, 10) == 1
%         bp_text=text(10 , 12, 'B_P', 'fontsize',  16,'fontweight', 'bold');
%     end
%         ba_text=text(10 , 34, 'B_A','fontsize', 16,'fontweight', 'bold' );
%     
%     axis square
% end
% sgtitle('A + P outcomes for different parameter sets', 'fontsize', 18, 'fontweight', 'bold')

