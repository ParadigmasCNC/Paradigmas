function EnviarMarca(marca)
    global pportobj EEG
    if EEG    
        write(pportobj,marca,"uint8") 
    else
        display(marca);
    end
end