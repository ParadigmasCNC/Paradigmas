%% Settings for image sequence experiment
% Change these to suit your experiment!
% how many trials?
nTrials = 32;
% Path to text file input (optional; for no text input set to 'none')
%textFile = 'targetPrompt.txt';
textFile = 'none';

% Response keys (optional; for no subject response use empty list)
yeskey = '6';
nokey= '4';
%responseKeys = {};

% Number of trials to show before a break (for no breaks, choose a number
% greater than the number of trials in your experiment)
breakAfterTrials = 10;

% How long (in seconds) each image in the RSVP sequence will stay on screen
numSecs = 5; 

% Text color: choose a number from 0 (black) to 255 (white)
textColor = 0;

% Image format of the image files in this experiment (eg, jpg, gif, png, bmp)
imageFormat = 'jpg';

% How long to wait (in seconds) for subject response before the trial times out
trialTimeout = 5;

% How long to pause in between trials (if 0, the experiment will wait for
% the subject to press a key before every trial)
timeBetweenTrials = 2;