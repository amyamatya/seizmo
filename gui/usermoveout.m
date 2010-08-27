function [data,mvo,ax]=usermoveout(data,varargin)
%USERMOVEOUT    Interactivly add a distance-dependent moveout
%
%    Usage:    data=usermoveout(data)
%              data=usermoveout(data,'field1',value1,...,'fieldN',valueN)
%              [data,mvo]=usermoveout(...)
%              [data,mvo,ax]=usermoveout(...)
%
%    Description: DATA=USERMOVEOUT(DATA) presents an interactive menu and
%     record section plot (arranged by degree distance) to facilitate
%     timeshifting data by a particular moveout.  This is useful for
%     pre-aligning on a particular seismic phase before stacking or
%     windowing.  All moveouts are expressed in seconds per degree and are
%     applied relative to the lowest record's degree distance (given by the
%     GCARC field).
%
%     DATA=USERMOVEOUT(DATA,'FIELD1',VALUE1,...,'FIELDN',VALUEN) passes
%     field/value pairs to RECORDSECTION to allow plot customization.
%
%     [DATA,MVO]=USERMOVEOUT(...) returns a struct MVO with the following
%     fields:
%      MVO.moveout  --  moveout used in calculating the shifts (in sec/deg)
%      MVO.shift    --  actual time shifts applied to the data (in sec)
%
%     [DATA,MVO,AX]=USERMOVEOUT(...) returns the record section's axes
%      handle in AX.
%
%    Notes:
%     - Make sure you have the GCARC field set for all records!
%
%    Header changes: NZYEAR, NZJDAY, NZHOUR, NZMIN, NZSEC, NZMSEC
%                    A, B, E, F, O, Tn
%
%    Examples:
%     Typically one runs this followed by USERWINDOW & USERTAPER:
%      [data,mvo,ax]=usermoveout(data);
%      [data,win,ax(2:3)]=userwindow(data);
%      [data,tpr,ax(4:5)]=usertaper(data);
%
%    See also: USERWINDOW, USERTAPER, USERALIGN

%     Version History:
%        Mar. 16, 2010 - initial version
%        Mar. 18, 2010 - made robust to menu closing, reorder menu buttons
%        Aug. 26, 2010 - update for axes plotting output, checkheader fix
%
%     Written by Garrett Euler (ggeuler at wustl dot edu)
%     Last Updated Aug. 26, 2010 at 10:00 GMT

% todo:

% check nargin
error(nargchk(1,inf,nargin));

% check data structure
versioninfo(data,'dep');

% turn off struct checking
oldseizmocheckstate=seizmocheck_state(false);

% attempt header check
try
    % check headers
    data=checkheader(data);
    
    % turn off header checking
    oldcheckheaderstate=checkheader_state(false);
catch
    % toggle checking back
    seizmocheck_state(oldseizmocheckstate);
    
    % rethrow error
    error(lasterror);
end

% attempt to add moveout
try
    % get distance
    gcarc=getheader(data,'gcarc');
    mindist=min(gcarc);
    
    % default moveout
    mvo.moveout=0;
    mvo.adjust=(gcarc-mindist)*mvo.moveout;
    
    % outer loop - only breaks free on user command
    happy_user=false; reax={};
    while(~happy_user)
        % plot records vs distance
        ax=recordsection(timeshift(data,mvo.adjust),varargin{:},reax{:});
        
        % get choice from user
        choice=menu('Adjust Moveout of the Data?','YES','NO');
        
        % act on choice
        switch choice
            case 0 % menu closed
                if(ishandle(ax))
                    reax={'ax' ax};
                else
                    reax={};
                end
            case 1
                % ask user how much
                choice=menu('Adjust moveout by how much?',...
                    ['NONE - KEEP CURRENT (' num2str(mvo.moveout) ')'],...
                    '+0.500 sec/deg',...
                    '+0.250 sec/deg',...
                    '+0.100 sec/deg',...
                    '+0.050 sec/deg',...
                    '+0.025 sec/deg',...
                    '+0.010 sec/deg',...
                    '-0.010 sec/deg',...
                    '-0.025 sec/deg',...
                    '-0.050 sec/deg',...
                    '-0.100 sec/deg',...
                    '-0.250 sec/deg',...
                    '-0.500 sec/deg',...
                    'ADD CUSTOM');

                switch choice
                    case 1
                        % do nothing
                    case 2
                        mvo.moveout=mvo.moveout+0.5;
                    case 3
                        mvo.moveout=mvo.moveout+0.25;
                    case 4
                        mvo.moveout=mvo.moveout+0.1;
                    case 5
                        mvo.moveout=mvo.moveout+0.05;
                    case 6
                        mvo.moveout=mvo.moveout+0.025;
                    case 7
                        mvo.moveout=mvo.moveout+0.01;
                    case 8
                        mvo.moveout=mvo.moveout-0.01;
                    case 9
                        mvo.moveout=mvo.moveout-0.025;
                    case 10
                        mvo.moveout=mvo.moveout-0.05;
                    case 11
                        mvo.moveout=mvo.moveout-0.1;
                    case 12
                        mvo.moveout=mvo.moveout-0.25;
                    case 13
                        mvo.moveout=mvo.moveout-0.5;
                    case 14
                        % customized
                        tmp=inputdlg(...
                            'Add how much moveout (in sec/deg)? [0]:',...
                            'Custom Moveout',1,{'0'});
                        if(~isempty(tmp))
                            try
                                tmp=str2double(tmp{:});
                                if(isscalar(tmp) && isreal(tmp))
                                    mvo.moveout=mvo.moveout+tmp;
                                end
                            catch
                                % do not change mvo.moveout
                            end
                        end
                end
                mvo.adjust=(gcarc-mindist)*mvo.moveout;

                % close old figure
                if(ishandle(ax))
                    reax={'ax' ax};
                else
                    reax={};
                end
            case 2
                happy_user=true;
        end
    end
    
    % apply moveout
    if(mvo.moveout)
        data=timeshift(data,mvo.adjust);
    end
    
    % toggle checking back
    seizmocheck_state(oldseizmocheckstate);
    checkheader_state(oldcheckheaderstate);
catch
    % toggle checking back
    seizmocheck_state(oldseizmocheckstate);
    checkheader_state(oldcheckheaderstate);
    
    % rethrow error
    error(lasterror)
end

end