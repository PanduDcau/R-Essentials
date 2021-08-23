clc;
clear;
clear all;
R= [-inf,0,0,-inf,-inf,-inf,-inf,-inf,-inf,-inf,-inf,-inf,-inf,-inf;
    0,-inf,-inf,0,-inf,-inf,-inf,-inf,-inf,-inf,-inf,-inf,-inf,-inf;
    0,-inf,-inf,0,-inf,-inf,-inf,-inf,-inf,-inf,0,-inf,-inf,-inf;
    -inf,0,0,-inf,0,-inf,-inf,-inf,-inf,-inf,-inf,-inf,0,-inf;
    -inf,-inf,-inf,0,-inf,0,0,-inf,-inf,-inf,-inf,-inf,-inf,-inf;
    -inf,-inf,-inf,-inf,0,-inf,-inf,0,-inf,-inf,-inf,-inf,-inf,0;
    -inf,-inf,-inf,-inf,0,-inf,-inf,0,-inf,-inf,-inf,-inf,0,-inf;
    -inf,-inf,-inf,-inf,-inf,0,0,-inf,100,-inf,-inf,0,-inf,-inf;
    -inf,-inf,-inf,-inf,-inf,-inf,-inf,0,-inf,-inf,-inf,-inf,-inf,-inf;
    -inf,-inf,-inf,-inf,-inf,-inf,-inf,-inf,-inf,-inf,-inf,-inf,0,-inf;
    -inf,-inf,0,-inf,-inf,-inf,-inf,-inf,-inf,-inf,-inf,0,-inf,-inf;
    -inf,-inf,-inf,-inf,-inf,-inf,-inf,0,-inf,-inf,0,-inf,-inf,-inf;
    -inf,-inf,-inf,0,-inf,-inf,0,-inf,-inf,0,-inf,-inf,-inf,-inf;
    -inf,-inf,-inf,-inf,-inf,0,-inf,-inf,-inf,-inf,-inf,-inf,-inf,-inf;]

gamma = 0.8; % the Gamma (learning parameter).
goalstate = 9; % the goal state is 5
q= zeros(size(R));
 for episode=1:10000
   %selec a random initial state=2
   y=randperm(size(R,2));
   state = y(1)
 
  while state~= goalstate %find the all posible actions from the state
    actions= find(R(state,:)>=0);
    if size (actions,2)>0 %select one action randomly
      i=randperm(size(actions,2));
      action= actions(i(1));
    end
    %Return a column vector with the max values of each rows
    qMax = max(q, [],2);
    %compute the q values
     q(state, action) = R(state, action) + gamma.*qMax(action);
     % Transition to the next state
     state=action;
     
  end
 end 

% normalized q
         g=max(qMax);
         if g>0,
         q= 100*q./g;
         end 
         disp(q)
         
disp('The q maximun values are:')
disp(qMax);
disp('The most effient path is:')
state=10;
disp(state);

while state~=goalstate
  [mx,action] =max(q(state,:));
  state =action;
  disp(state)
 
end