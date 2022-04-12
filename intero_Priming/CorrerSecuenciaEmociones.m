function [log, exit] = CorrerSecuenciaEmociones(bloque, n_bloque, hd, teclas, log)

    ExitKey = teclas.ExitKey;
      
    botones = teclas.emociones;
    botones_salteado = teclas.botones_salteado;
    
    TITULO = 'Seleccione la opcion correcta';
    
    negativas = { 'Ang' 'Dis' 'Fea' 'Sad' };
    
    practica = true;
    texturas = bloque.texturas{n_bloque};
    if isfield(bloque, 'archivos')
        archivos = bloque.archivos{n_bloque};
        practica = false;
    end    
    
    global TAMANIO_TEXTO
    global TAMANIO_INSTRUCCIONES
    global EEG

    
    %% INSTRUCCIONES
    EmocionesInstrucciones(bloque.instrucciones, TAMANIO_INSTRUCCIONES, bloque.textos_botones, hd);
    Screen('Flip', hd.window);
    exit = EsperarBoton(teclas.Continuar, teclas.ExitKey);
    if exit
        return;
    end
    if isfield(bloque, 'mensaje_practica')
        TextoCentrado(bloque.mensaje_practica, TAMANIO_INSTRUCCIONES, hd);
        Screen('Flip', hd.window);
        exit = EsperarBoton(teclas.Continuar, teclas.ExitKey);
        if exit
            return;
        end
    end
    
    %% FIJACION
    TextoCentrado('+', TAMANIO_TEXTO, hd);
    Screen('Flip', hd.window);
    if ~practica
        EnviarMarca(150);
    end
    
    [exit, ~, ~, saltear_bloque] = Esperar(0.5, ExitKey, {}, botones_salteado);
    if exit || saltear_bloque
        return;
    end

    %% VACIO
    Screen('Flip', hd.window);
    [exit, ~, ~, saltear_bloque] = Esperar(0.5, ExitKey, {}, botones_salteado);
    if exit || saltear_bloque
        return;
    end
          
    for i = 1:length(texturas)
        
        %% IMAGEN
        DibujarTextura(texturas{i}, hd.window);  
        [~, OnSetTime] = Screen('Flip', hd.window);
        log_trial.imagen = OnSetTime;
        if ~practica
            EnviarMarca(bloque.codigos(archivos{i}))
        end
        [exit, ~, ~, saltear_bloque] = Esperar(0.2, ExitKey, {}, botones_salteado);
        if exit || saltear_bloque
            return;
        end
        
        
        %% VACIO
        [~, OnSetTime] = Screen('Flip', hd.window);
        log_trial.vacio = OnSetTime;
        [exit, ~, ~, saltear_bloque] = Esperar(0.8, ExitKey, {}, botones_salteado);
        if exit || saltear_bloque
            return;
        end

        
        %% PREGUNTA
        DibujarReferencias(hd, bloque.textos_botones, TAMANIO_INSTRUCCIONES);
        if i == 1
            TextoCentrado(TITULO, TAMANIO_TEXTO, hd);
        end
        [~, OnSetTime] = Screen('Flip', hd.window);
        if ~practica
            EnviarMarca(160);
        end

        log_trial.pregunta_tiempo = OnSetTime;
        [exit, respuesta, tiempo, saltear_bloque] = EsperarBotones(ExitKey, botones, botones_salteado);
        if exit || saltear_bloque
            return;
        end
              
        if ~practica
            
            log_trial.imagen_codigo = archivos{i};
            categoria = archivos{i}(5:7);
            respuesta_correcta = 'Positiva';
            if strcmp(categoria, 'Neu')
                respuesta_correcta = 'Neutral';
            else 
                for y = 1:length(negativas)
                   if strcmp(categoria, negativas{y})
                        respuesta_correcta = 'Negativa';
                   end
                end
            end
            
            log_trial.accuracy = 9;
            if ~isempty(respuesta)
                log_trial.respuesta = bloque.textos_botones{1, respuesta};
                if strcmp(log_trial.respuesta, respuesta_correcta)
                    log_trial.accuracy = 1;
                else
                    log_trial.accuracy = 0;
                end
            end
                        
            if ~isempty(respuesta) && ~practica
                EnviarMarca(log_trial.accuracy + 165);
            end
            
        end
        
        log_trial.respuesta_tiempo = tiempo;
        log_trial.reaction_time = log_trial.respuesta_tiempo - log_trial.pregunta_tiempo;
        
 
        
        %% CRUZ DE FIJACION
        TextoCentrado('+', TAMANIO_TEXTO, hd);
        [~, OnSetTime] = Screen('Flip', hd.window);
        if ~practica
            EnviarMarca(170);
        end
        log_trial.fijacion = OnSetTime;
        [exit, ~, ~, saltear_bloque] = Esperar((rand*0.1)+0.4, ExitKey, {}, botones_salteado);
        if exit || saltear_bloque
            return;
        end
        
        %% OFFSET
        [~, OnSetTime] = Screen('Flip', hd.window);        
        log_trial.offset_time = OnSetTime;
        [exit, ~, ~, saltear_bloque] = Esperar(0.5, ExitKey, {}, botones_salteado);
        if exit || saltear_bloque
            return;
        end
        
        if ~isempty(log)
            log{i} = log_trial;
        end

    end
    

end