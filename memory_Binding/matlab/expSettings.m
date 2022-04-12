function [design] = expSettings()

%....Define "DO" structure
design.Trials = 10;
design.debug  = ''; % 'screen' or 'key' or []; To-do: key debug mod
design.fontColor    = [255 0 0]; % FontColors in RGB; red letters.
design.ShowResultsToParticipant = 1;  % If 1 --> show results to participant

%-------------------------------------------------------------------------%
design.retentionTimes    = repmat(2,1,design.Trials); % allows for different retention times if wanted.
design.FixationDuration  = 2;                          % fixation duration (between trials) - to-do: use to get subject responses to.
design.SampleDuration    = 1;                          % sample images duration
design.TestDuration      = 2;                          % To-do: implement this duration and dont wait for answer.
%-------------------------------------------------------------------------%
end
