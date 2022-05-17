clear, clc, close all

% Generate Cues

[grid(:,:,1),grid(:,:,2)] = meshgrid(linspace(0,1,30));

grid = reshape(grid,[],2);

gamut = [0.640, 0.3300;...
    0.2100, 0.7100;...
    0.1500 	0.0600]; % Adobe RGB (for now, change as neccessary) Source: https://en.wikipedia.org/wiki/Adobe_RGB_color_space#Specifications

in = inpolygon(grid(:,1),grid(:,2),...
    gamut(:,1),gamut(:,2));

grid_in = grid(in,:);

nTrials = 1000;
cues = grid_in(randi(size(grid_in,1),nTrials,1),:);

try
    DrawChromaticity % requires psychtoolbox
catch
    figure, hold on, axis equal
end

plot([gamut(:,1);gamut(1,1)],[gamut(:,2);gamut(1,2)],'k')
scatter(grid(:,1),grid(:,2),'ro','MarkerEdgeAlpha',0.1)
scatter(grid_in(:,1),grid_in(:,2),'kx')

%% Generate responses without bias

noiseVal = 0.1;
responses = cues + randn(size(cues))*noiseVal;

scatter(responses(:,1),responses(:,2),'b.')

% add biases
% find closest attractor
% modify response such that

% pull responses back inside response space
for i = 1:size(responses,1)
    in(i) = inpolygon(responses(i,1), responses(i,2),...
        gamut(:,1), gamut(:,2));
    if ~in(i)
        [d_min(i), response_in_x(i), response_in_y(i)] = p_poly_dist(responses(i,1), responses(i,2),...
            gamut(:,1), gamut(:,2),1);
    else
        response_in_x(i) = responses(i,1);
        response_in_y(i) = responses(i,2);
    end
end

responses_in = [response_in_x; response_in_y];
 
scatter(response_in_x,response_in_y,'g.')
quiver(responses(~in,1),responses(~in,2),...
    response_in_x(~in)'-responses(~in,1),...
    response_in_y(~in)'-responses(~in,2),...
    'off') % scaling off





