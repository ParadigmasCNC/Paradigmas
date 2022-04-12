function [log, exit] = BloquePreguntas(bloque,hd, teclas)

    exit = false;
    log = [];
        
    %% Question Texts
    preguntas = cell(2,1); % Preallocate for speed
    
    if strcmp(bloque,'RestExtero')
        % First question definition  
        textos_opciones.pregunta = 'Hur tydligt k�nde eller h�rde du hj�rtslagen?';
        textos_opciones.minimo = 'Inget';
        textos_opciones.medio = '';
        textos_opciones.maximo = 'V�ldigt mycket';
    elseif strcmp(bloque,'Extero')
        % First question definition  
        textos_opciones.pregunta = 'Hur tydligt k�nde eller h�rde du hj�rtslagen?';
        textos_opciones.minimo = 'Inget';
        textos_opciones.medio = '';
        textos_opciones.maximo = 'V�ldigt mycket';
    elseif strcmp(bloque,'RestIntero')
        % First question definition  
        textos_opciones.pregunta = 'Hur tydligen k�nde eller h�rde du dina egna hj�rtslag?';
        textos_opciones.minimo = 'Inget';
        textos_opciones.medio = '';
        textos_opciones.maximo = 'V�ldigt mycket';
    elseif strcmp(bloque,'Intero')
        % First question definition  
        textos_opciones.pregunta = 'Hur tydligen k�nde eller h�rde du dina egna hj�rtslag?';
        textos_opciones.minimo = 'Inget';
        textos_opciones.medio = '';
        textos_opciones.maximo = 'V�ldigt mycket';
    end
    % Save in var
    preguntas{1} = textos_opciones;
    
    % Second question definition
    textos_opciones.pregunta = 'Hur exakta tror du dina svar?';
    % Save in var
    preguntas{2} = textos_opciones;
    
    % Iter through questions
    for j = 1:length(preguntas)
        Screen('Flip',hd.window);
        WaitSecs(0.5);
        [exit, log_respuesta, saltear_bloque] = Respuesta(preguntas{j}, teclas, hd);
        if exit || saltear_bloque
            return;
        end
        log_bloque.respuesta = log_respuesta; % Save answer in log
        log{j}               = log_bloque;    %#ok<AGROW>        
    end   
end