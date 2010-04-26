function [map]=fire(m)
%FIRE    Black-Blue-Violet-Red-Yellow-White colormap
%
%    Usage:    map=fire(m)
%
%    Description: MAP=FIRE(M) returns a Mx3 matrix of RGB color values
%     going from black to blue to violet to red to yellow to white.  This
%     colormap can make an eerie night fire.  It is used primarily for
%     spectrogram plots.  FIRE by itself sets M to match the current
%     figure's colormap size.  If no figure exists, one is created.
%
%    Notes:
%
%    Examples:
%     Set the current figure's colormap:
%      colormap(fire)
%
%    See also: BLUE2RED, GREEN2BLUE, SPLIT, SEIS, OCEAN, DRYWET,
%              GEBCO, SEALAND, RAINBOW, RELIEF, GLOBE_SEA, GLOBE_LAND,
%              SEALAND_SEA, SEALAND_LAND, TOPO_LAND, RITZ, RED2GREEN

%     Version History:
%        Apr. 26, 2010 - initial version
%
%     Written by Garrett Euler (ggeuler at wustl dot edu)
%     Last Updated Apr. 26, 2010 at 01:40 GMT

% todo:

if nargin < 1, m = size(get(gcf,'colormap'),1); end
x=(0:0.2:1)';
map=[interp1q(x,[0 0 1 1 1 1]',(0:m-1)'/(m-1)) ...
     interp1q(x,[0 0 0 0 1 1]',(0:m-1)'/(m-1)) ...
     interp1q(x,[0 1 1 0 0 1]',(0:m-1)'/(m-1))];

% fix out-of-bounds due to interpolation
map(map<0)=0;
map(map>1)=1;

end
