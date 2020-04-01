function coronavirus(TF) 
 % Model Variable:  
 %   S1 (Isolated), 
 %   S2 (Susceptible), 
 %   I (Infected),  
 %   R (Recoverd or Dead) 
 %   
 %   dS1/dt =  -c1*S1  + c2*S1 
 %   dS2/dt  = c1*S1  -  c2*S2  -  beta*S2*I 
 %   dI/dt  =  beta*S2*I  - alpha*I
 %   dR/dt  =  alpha*I
 % 
 %   Notes: 
 %    alpha:  Recovery Ratea 
 %    beta:  infectiveness parameter 
 %    c1:  Rate at which isolated people go back into society 
 %    c2:  Rate at which susceptible move back into isolation 
 %    -No Social Distancing:  c1=c2=0
 %   -Strong Social Distance (with some leakage):  c2 > c1 > 0
 %   -Total Population:  N = S1+S2+I+R = 1  (so S1,S2,I,R are proportions of population in
 %   said class.) 
 % 
 %    
 
 % 
 
 if nargin==0 
    TF=365; % 1 year run 
 end
  alpha=1/14;   % recovery rate (14 days) 
  beta=4*alpha;  % R_0 =  beta/alpha 
  c1=0.25;  % people leave isolation rate of every 4 days 
  c2=2*c1;  % go back into isolation rather quickly 
  
  % solve ODE on (See below for the model "F") 
  initCond = [0 0.995 0.005 0]; %  0% isolated, 99.5% Not infected ,  0.05%  infected,  essentialy 0% recoverd 
  timeInterval = [0 TF];
  options = odeset('NonNegative',[1 1 1 1],'relTol',1e-4); % non-negative solution; modest accuracy 
  solution = ode15s(@F,timeInterval, initCond,options); 
  tValues=0:0.5:TF;  % 1/2 day measurments 
  yValues=deval(solution,tValues);  % evalue solution every 1/2 day (12 hours) 
  
  S1V=yValues(1,:);  % isolated solution 
  S2V=yValues(2,:);  % suceptible solution 
  IV=yValues(3,:);  % infected solution
  RV=yValues(4,:);  % recovered/dead
  
  figure(1);
  subplot(2,2,1); 
  title('Proportion of People In Isoltation','FontSize',14); 
  plot(tValues,S1V,'b-','LineWidth',2);
  
  subplot(2,2,2); 
  plot(tValues,S2V,'k-','LineWidth',2);
  title('Proportion of People Susceptible','FontSize',16); 
  
  subplot(2,2,3); 
  plot(tValues,IV,'r-','LineWidth',2);
  title('Proportion of People Infected','FontSize',14);
  
  subplot(2,2,4);
  plot(tValues,RV,'g-','LineWidth',2);
  title('Proportion of People Recovered/Dead','FontSize',14); 
    % matlab ODE input function  (nested) 
    function dydt=F(t,y)
        S1=y(1);
        S2=y(2); 
        I=y(3);
        R=y(4); 
        dS1_dt= c2*S2 - c1*S1 ;
        dS2_dt= -c2*S2 + c1*S1 - beta*(S2)*I;
        %  dS3dt = -beta*S3*I; was messing around with a subclass of
        %  'permantly exponsed' people
        dI_dt = beta*S2*I - alpha*I;    % if S3 included, would be beta*(S2+S3)*I
        dR_dt=alpha*I; 
        dydt=[dS1_dt;dS2_dt;dI_dt;dR_dt];   % ODE output for system 
     end 
end
