function [Bienvenido,Intro,Intro2,Intro3,GetReady,SiguienteAudio,Gracias] = getIntroTxts(paths)
    % Bienvenido/a
    fileID     = fopen([paths.stimuliPath,'\Bienvenido.txt'], 'r');
    formatSpec = '%c'; % Format to read white spaces too
    Bienvenido = fscanf(fileID,formatSpec);
    fclose(fileID);
    
    % Intro
    fileID     = fopen([paths.stimuliPath,'\Intro.txt'], 'r');
    formatSpec = '%c'; % Format to read white spaces too
    Intro      = fscanf(fileID,formatSpec);
    fclose(fileID);

    % Intro2
    fileID     = fopen([paths.stimuliPath,'\Intro2.txt'], 'r');
    formatSpec = '%c'; % Format to read white spaces too
    Intro2      = fscanf(fileID,formatSpec);
    fclose(fileID);

    % Intro3
    fileID     = fopen([paths.stimuliPath,'\Intro3.txt'], 'r');
    formatSpec = '%c'; % Format to read white spaces too
    Intro3      = fscanf(fileID,formatSpec);
    fclose(fileID);

    % Get ready
    fileID     = fopen([paths.stimuliPath,'\GetReady.txt'], 'r');
    formatSpec = '%c'; % Format to read white spaces too
    GetReady   = fscanf(fileID,formatSpec);
    fclose(fileID);
    
    % Next Audio
    fileID     = fopen([paths.stimuliPath,'\SiguienteAudio.txt'], 'r');
    formatSpec = '%c'; % Format to read white spaces too
    SiguienteAudio = fscanf(fileID,formatSpec);
    fclose(fileID);
    
    % Gracias por participar
    fileID     = fopen([paths.stimuliPath,'\Gracias.txt'], 'r');
    formatSpec = '%c'; % Format to read white spaces too
    Gracias = fscanf(fileID,formatSpec);
    fclose(fileID);
end