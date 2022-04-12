
function [log point]=trials_run(numberoftrials2run,hd,iti,raw,point,name,date,EEG,marca)


%% Declare constant & variables

arrow_left=sprintf('%s','<--- NO');
arrow_right=sprintf('%s','SI --->');
question=sprintf('%s','¿Estas son las mismas palabras que vio en la pantalla anterior?') ;

white=hd.white;
black=hd.black;

leftKey = KbName('leftarrow');
rightKey = KbName('rightarrow');

% Define log header
log(1,1:8) = {'TrialNumber', 'TrialStart', 'ListOneStart', 'ListOneEnd', 'ListTwoStart', 'ReactionTime', 'Response', 'Accuracy'};
log(2:numberoftrials2run+1,:) = num2cell(zeros(numberoftrials2run,8));
%% Begin  loop
init_time=GetSecs;

for trial=1:numberoftrials2run

    log{trial+1,1}=trial;
    log{trial+1,2}=GetSecs-init_time;
    
    Screen('FillRect',hd.window,black)            
    DrawFormattedText(hd.window, '+', 'center',...
                'center', white);
            
    if EEG
        EnviarMarca(marca.FixCrossStart)
    end
    Screen('Flip',hd.window,0,1); %%  
    if EEG
        EnviarMarca(marca.FixCrossEnd)
    end
    
    iti.time=iti.xmin+rand(1)*(iti.xmax-iti.xmin);
    WaitSecs(iti.time/1000);
    
 
    word_number=cell2mat(raw(point,2));
    correct_ans=cell2mat(raw(point,3));
     
    switch word_number
    
        case 3
        
            for i=1:3
                
                point=point+1;
                w(i).stim= cell2mat(raw(point,1));
                w(i).test= cell2mat(raw(point,2));
            end
            if contains({w(:).stim},{w().test})
                congruent = 1;
            else
                congruent = 2;
            end
            %Stim
            % ACA ESTIMULOS 3 EEG
            if EEG
                EnviarMarca(marca.estimuloTres)
            end
            Screen('FillRect',hd.window,black)                     
            DrawFormattedText(hd.window, sprintf('%c',w(1).stim), 'center',...
                hd.centery * 0.8, white);
            DrawFormattedText(hd.window, sprintf('%c',w(2).stim), 'center',...
                hd.centery * 0.95, white);          
            DrawFormattedText(hd.window, sprintf('%c',w(3).stim), 'center',...
                hd.centery * 1.10, white);
           
            Screen('Flip',hd.window,0,1); %%
            
            log{trial+1,3}=GetSecs-init_time; %LOG STIM TRIGG Time
           
            point=point+1;
          
            
            WaitSecs(hd.times(1).stim);
            
            
            
            Screen('FillRect',hd.window,black);
            Screen('Flip',hd.window,0,1); %%

            log{trial+1,4}=GetSecs-init_time; %LOG BLANK TRIGG Time
            if EEG
                EnviarMarca(marca.estimuloTresFin);
            end
            tic
            % Check if exit during blank time
            while(toc<hd.times(1).blank)
            
                [~, ~, keyCode, ~] = KbCheck();
    
                if (find(keyCode) == KbName('q'))
                    
                    save(['Log/' name '_' date(1:11) '_incomplete.mat'],'log');
                    Screen('CloseAll'); % Cierro ventana del Psychtoolbox
                    error('Finalizando script...')
                    
                end

            end
            
 
            %TEST
            
            Screen('FillRect',hd.window,black)                     
            
            
            DrawFormattedText(hd.window, question, 'center',...
                hd.centery * 0.2, white);
             DrawFormattedText(hd.window, arrow_left, hd.centerx * 0.2,...
                hd.centery * 1.7, white);
            DrawFormattedText(hd.window, arrow_right, hd.centerx * 1.6,...
                hd.centery * 1.7, white);
           
            % ACA ESTIMULOS 3 EEG
            if EEG
                if congruent == 1
                    EnviarMarca(marca.estimuloTresC);
                else
                    EnviarMarca(marca.estimuloTresIc);
                end
            end
            DrawFormattedText(hd.window, sprintf('%c',w(1).test), 'center',...
                hd.centery * 0.8, white);
            DrawFormattedText(hd.window, sprintf('%c',w(2).test), 'center',...
                hd.centery * 0.95, white);          
            DrawFormattedText(hd.window, sprintf('%c',w(3).test), 'center',...
                hd.centery * 1.10, white);
            
            
            
            Screen('Flip',hd.window,0,1); %%
 
            log{trial+1,5}=GetSecs-init_time; %LOG TEST TRIGG Time
           
            
            tic
            
            out=false;
            
            while toc<hd.times(1).test && out == false
            
                [keyIsDown,secs, keyCode] = KbCheck;

                if keyCode(rightKey)
                    out = true;
                    if EEG
                        EnviarMarca(marca.si);
                    end
                    log{trial+1,6}=GetSecs-init_time-log{trial+1,5}; %LOG RT Time
                    log{trial+1,7}=2; %LOG Answer  
                    
                    if (correct_ans==2)
                        
                        log{trial+1,8}=1; % OK
                    else
                        
                        log{trial+1,8}=0;
                    end
                    

                elseif keyCode(leftKey)
                    out = true;
                    
                    if EEG
                        EnviarMarca(marca.no);
                    end
                    log{trial+1,6}=GetSecs-init_time-log{trial+1,5}; %LOG RT Time
                    log{trial+1,7}=1; %LOG Answer (NO)
                    
                    if (correct_ans==1)
                        
                        log{trial+1,8}=1;
                        
                    else
                        
                        log{trial+1,8}=0;
                        
                    end
                    
                else %if 'q' exit
                    
                    if  (find(keyCode) == KbName('q'))
                        
                        save(['Log/' name '_' date(1:11) '_incomplete.mat'],'log');
                        Screen('CloseAll'); % Cierro ventana del Psychtoolbox
                        error('Finalizando script...')
                        
                    end
 
                    

                end
                
            end
            if EEG
                if congruent == 1
                    EnviarMarca(marca.estimuloTresCFin);
                else
                    EnviarMarca(marca.estimuloTresIcFin);
                end
            end
        case 4
            
            for i=1:4
            
                point=point+1;
                w(i).stim= cell2mat(raw(point,1));
                w(i).test= cell2mat(raw(point,2));
            end

            if contains({w(:).stim},{w(:).test})
                congruent = 1;
            else
                congruent = 2;
            end
            Screen('FillRect',hd.window,black)
            % ACA ESTIMULOS EEG 4
            if EEG
                EnviarMarca(marca.estimuloCuatro)
            end
            DrawFormattedText(hd.window, sprintf('%c',w(1).stim), 'center',...
                hd.centery * 0.70, white);
            DrawFormattedText(hd.window, sprintf('%c',w(2).stim), 'center',...
                hd.centery * 0.85, white);          
            DrawFormattedText(hd.window, sprintf('%c',w(3).stim), 'center',...
                hd.centery * 1, white);
            DrawFormattedText(hd.window, sprintf('%c',w(4).stim), 'center',...
                hd.centery * 1.15, white);
            
            Screen('Flip',hd.window,0,1); %%
 
            
            log{trial+1,3}=GetSecs-init_time; %LOG STIM TRIGG Time
           
            point=point+1;
            
            WaitSecs(hd.times(2).stim);
                        
            Screen('FillRect',hd.window,black);
            Screen('Flip',hd.window,0,1); %%
            
            log{trial+1,4}=GetSecs-init_time; %LOG BLANK TRIGG Time
            if EEG
                EnviarMarca(marca.estimuloCuatroFin);
            end
            tic
            
            while(toc<hd.times(1).blank)
            
                [~, ~, keyCode, ~] = KbCheck();
                
                if (find(keyCode) == KbName('q'))
                    
                    save(['Log/' name '_' date(1:11) '_incomplete.mat'],'log');
                    Screen('CloseAll'); % Cierro ventana del Psychtoolbox
                    error('Finalizando script...')
                    
                end

            end
            
            
            %TEST
            
            Screen('FillRect',hd.window,black)
            
            DrawFormattedText(hd.window, question, 'center',...
                hd.centery * 0.2, white);
           
             DrawFormattedText(hd.window, arrow_left, hd.centerx * 0.2,...
                hd.centery * 1.7, white);
            DrawFormattedText(hd.window, arrow_right, hd.centerx * 1.6,...
                hd.centery * 1.7, white);
            
            % ACA ESTIMULOS EEG 4
            if EEG
                if congruent == 1
                    EnviarMarca(marca.estimuloCuatroC);
                else
                    EnviarMarca(marca.estimuloCuatroIc);
                end
            end
            DrawFormattedText(hd.window, sprintf('%c',w(1).test), 'center',...
                hd.centery * 0.70, white);
            DrawFormattedText(hd.window, sprintf('%c',w(2).test), 'center',...
                hd.centery * 0.85, white);          
            DrawFormattedText(hd.window, sprintf('%c',w(3).test), 'center',...
                hd.centery * 1, white);
            DrawFormattedText(hd.window, sprintf('%c',w(4).test), 'center',...
                hd.centery * 1.15, white);
            Screen('Flip',hd.window,0,1); %%
 
            log{trial+1,5}=GetSecs-init_time; %LOG TEST TRIGG Time
           
            
            tic
            
            out=false;
            
            while toc<hd.times(2).test && out == false
            
                [keyIsDown,secs, keyCode] = KbCheck;

                if keyCode(rightKey)
                    out = true;
                    if EEG
                        EnviarMarca(marca.si);
                    end
                    log{trial+1,6}=GetSecs-init_time-log{trial+1,5}; %LOG RT Time
                    log{trial+1,7}=2; %LOG Answer  (YES)
                    
                    if (correct_ans==2)
                    
                        log{trial+1,8}=1;
                        
                    else
                        
                        log{trial+1,8}=0;
                        
                    
                    end
                    
                elseif keyCode(leftKey)
                    out = true;
                    if EEG
                        EnviarMarca(marca.no);
                    end
                    log{trial+1,6}=GetSecs-init_time-log{trial+1,5}; %LOG RT Time
                    log{trial+1,7}=1; %LOG Answer (NO)
             
                    if (correct_ans==1)
                        
                        log{trial+1,8}=1;
                        
                    else
                        
                        log{trial+1,8}=0;
                        
                        
                    end
                    
                else
                    
                    if  (find(keyCode) == KbName('q'))
                        
                        save(['Log/' name '_' date(1:11) '_incomplete.mat'],'log');
                        Screen('CloseAll'); % Cierro ventana del Psychtoolbox
                        error('Finalizando script...')
                        
                    end
     
                end
            end
            if EEG
                if congruent == 1
                    EnviarMarca(marca.estimuloCuatroCFin);
                else
                    EnviarMarca(marca.estimuloCuatroIcFin);
                end
            end
            
         
        case 5
          
            for i=1:5
            
                point=point+1;
                w(i).stim= cell2mat(raw(point,1));
                w(i).test= cell2mat(raw(point,2));
            end

            if contains({w(:).stim},{w(:).test})
                congruent = 1;
            else
                congruent = 2;
            end
            Screen('FillRect',hd.window,black)
            
            % ACA ESTIMULOS 5 EEG
            if EEG
                EnviarMarca(marca.estimuloCinco)
            end
            DrawFormattedText(hd.window, sprintf('%c',w(1).stim), 'center',...
                hd.centery * 0.65, white);
            DrawFormattedText(hd.window, sprintf('%c',w(2).stim), 'center',...
                hd.centery * 0.80, white);          
            DrawFormattedText(hd.window, sprintf('%c',w(3).stim), 'center',...
                hd.centery * 0.95, white);
            DrawFormattedText(hd.window, sprintf('%c',w(4).stim), 'center',...
                hd.centery * 1.10, white);
            DrawFormattedText(hd.window, sprintf('%c',w(5).stim), 'center',...
                hd.centery * 1.25, white);
            
            
            Screen('Flip',hd.window,0,1); %%
            
            log{trial+1,3}=GetSecs-init_time; %LOG STIM TRIGG Time
            
            point=point+1;
 
            WaitSecs(hd.times(3).stim);
                        
            Screen('FillRect',hd.window,black);
            Screen('Flip',hd.window,0,1); %%
            if EEG
                EnviarMarca(marca.estimuloCincoFin);
            end
            log{trial+1,4}=GetSecs-init_time; %LOG BLANK TRIGG Time
            
            tic
            
            while(toc<hd.times(1).blank)
            
                [~, ~, keyCode, ~] = KbCheck();
    
                if (find(keyCode) == KbName('q'))
                    
                    save(['Log/' name '_' date(1:11) '_incomplete.mat'],'log');
                    Screen('CloseAll'); % Cierro ventana del Psychtoolbox
                    error('Finalizando script...')
                    
                end

            end
            
            %TEST
            
            Screen('FillRect',hd.window,black)
            
            DrawFormattedText(hd.window, question, 'center',...
                hd.centery * 0.2, white);
           
             DrawFormattedText(hd.window, arrow_left, hd.centerx * 0.2,...
                hd.centery * 1.7, white);
            DrawFormattedText(hd.window, arrow_right, hd.centerx * 1.6,...
                hd.centery * 1.7, white);
            
            % ACA ESTIMULOS 5 EEG
            if EEG
                if congruent == 1
                    EnviarMarca(marca.estimuloCincoC);
                else
                    EnviarMarca(marca.estimuloCincoIc);
                end
            end
            DrawFormattedText(hd.window, sprintf('%c',w(1).test), 'center',...
                hd.centery * 0.65, white);
            DrawFormattedText(hd.window, sprintf('%c',w(2).test), 'center',...
                hd.centery * 0.80, white);          
            DrawFormattedText(hd.window, sprintf('%c',w(3).test), 'center',...
                hd.centery * 0.95, white);
            DrawFormattedText(hd.window, sprintf('%c',w(4).test), 'center',...
                hd.centery * 1.10, white);
            DrawFormattedText(hd.window, sprintf('%c',w(5).test), 'center',...
                hd.centery * 1.25, white);
            Screen('Flip',hd.window,0,1); %%
 
            log{trial+1,5}=GetSecs-init_time; %LOG TEST TRIGG Time
           
            
            tic
            
            out=false;
            
            while toc<hd.times(3).test && out == false
            
                [keyIsDown,secs, keyCode] = KbCheck;
                if keyCode(rightKey)
                    out = true;
                    if EEG
                        EnviarMarca(marca.si);
                    end
                    log{trial+1,6}=GetSecs-init_time-log{trial+1,5}; %LOG RT Time
                    log{trial+1,7}=2; %LOG Answer  
                    
                    if (correct_ans==2)
                        
                        log{trial+1,8}=1;
                        
                    else
                        
                        log{trial+1,8}=0;
                        
                        
                    end
                    
                    
                elseif keyCode(leftKey)
                    out = true;
                    if EEG
                        EnviarMarca(marca.no);
                    end
                    log{trial+1,6}=GetSecs-init_time-log{trial+1,5}; %LOG RT Time
                    log{trial+1,7}=1; %LOG Answer
                    
                    if (correct_ans==1)
                        
                        log{trial+1,8}=1;
                        
                    else
                        
                        log{trial+1,8}=0;
                        
                        
                    end
                    
                else
                    
                    if  (find(keyCode) == KbName('q'))
                        
                        save(['Log/' name '_' date(1:11) '_incomplete.mat'],'log');
                        Screen('CloseAll'); % Cierro ventana del Psychtoolbox
                        error('Finalizando script...')
                        
                    end
 
                end
            end
            if EEG
                if congruent == 1
                    EnviarMarca(marca.estimuloCincoCFin);
                else
                    EnviarMarca(marca.estimuloCincoIcFin);
                end
            end
    end

end
