function utilFcn = MR_Toolbox_Utilities

%  Creata cell-list of available functions
fs={...
    'defaultButtonTags';...
    'retrieveNames';...
    'enableToolbarButtons';...
    'disableToolbarButtons';...
    'retrieveOrigData'; ...
    'restoreOrigData';...
    'findHiddenObj';...
    };

% Convert each name into a function handle available from structure M
for i=1:length(fs),
	utilFcn.(fs{i}) = str2func(fs{i});
end;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%START MULTI-TOOL SUPPORT FUNCTIONS%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% %%%%%%%%%%%%%%%%%%%%%%%%
%
function tags = defaultButtonTags %#ok<*DEFNU>>
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%
utilDispDebug;

tags = { ...
    'figWindowLevel',...
    'figPanZoom',...
    'figROITool',...
    'figViewImages',...
    'figPointTool',...
    'figRotateTool',...
    'figProfileTool'};
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% %%%%%%%%%%%%%%%%%%%%%%%%
%
function structNames = retrieveNames
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%
structNames.toolName            = '<Utils>';
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% %%%%%%%%%%%%%%%%%%%%%%%%
%
function [hToolbar_Children, origToolEnables, origToolStates ] = disableToolbarButtons(hToolbar, currentToolName) 
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%
dispDebug;
hRoot = groot;
old_SHH = hRoot.ShowHiddenHandles;
hRoot.ShowHiddenHandles = 'on';

hToolbar_Children = hToolbar.Children;

origToolEnables = cell(size(hToolbar_Children));
origToolStates  = cell(size(hToolbar_Children));


for i = 1:length(hToolbar_Children)
    if ~strcmpi(hToolbar_Children(i).Tag, currentToolName)
        if isprop(hToolbar_Children(i), 'Enable')
            origToolEnables{i} =  hToolbar_Children(i).Enable;
            hToolbar_Children(i).Enable ='off';
        end
        if isprop(hToolbar_Children(i), 'State')
            origToolStates{i}  =  hToolbar_Children(i).State;
            hToolbar_Children(i).Enable ='off';
        end
    end
end

hRoot.ShowHiddenHandles = old_SHH;
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% %%%%%%%%%%%%%%%%%%%%%%%%
%
%
function enableToolbarButtons(hToolbar_Children, origToolEnables, origToolStates)
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%
dispDebug;

for i = 1:length(hToolbar_Children)
    if isprop(hToolbar_Children(i), 'Enable') && ~isempty(origToolEnables{i})
        hToolbar_Children(i).Enable = origToolEnables{i};
    end
    if isprop(hToolbar_Children(i), 'State') && ~isempty(origToolStates{i})
        hToolbar_Children(i).State = origToolStates{i};
    end
end
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% %%%%%%%%%%%%%%%%%%%%%%%%
%
function propList = retrieveOrigData(hObjs,propList)
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Retrive previous settings for storage
dispDebug;

if nargin==1
    % basic list - typically modified figure properties
    propList = {...
        'WindowButtonDownFcn'; ...
        'WindowButtonMotionFcn'; ...
        'WindowButtonUpFcn'; ...
        'WindowKeyPressFcn'; ...
        'UserData'; ...
        'CloseRequestFcn'; ...
        'Pointer'; ...
        'PointerShapeCData'; ...
        'Tag' ...
        };
end

propList = repmat(propList, [1 1 length(hObjs)]);

for j = 1:length(hObjs)
    for i = 1:size(propList,1)
        propList{i,2,j} = hObjs(j).(propList{i,1});
    end
end
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% %%%%%%%%%%%%%%%%%%%%%%%%
%
function restoreOrigData(hFig, propList)
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Restore previous WBDF etc to restore state after WL is done.
dispDebug;
for j = 1:length(hFig)
    for i = 1:size(propList,1)
        hFig(j).(propList{i,1,j}) = propList{i,2,j};
    end
end
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% %%%%%%%%%%%%%%%%%%%%%%%%
%
function h = findHiddenObj(Handle, Property, Value)
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%
dispDebug;

h_root = groot;
old_SHH = h_root.ShowHiddenHandles;
h_root.ShowHiddenHandles = 'On';
if nargin <3
    h = findobj(Handle, Property);
else
    h = findobj(Handle, Property, Value);
end;
h_root.ShowHiddenHandles = old_SHH;
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%START LOCAL SUPPORT FUNCTIONS%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% %%%%%%%%%%%%%%%%%%%%%%%%
%
function  utilDispDebug(varargin)
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Print a debug string if global debug flag is set
global DB;

if DB
    objectNames = retrieveNames;
    x = dbstack;
    func_name = x(2).name;    loc = [];
    if length(x) > 3
        loc = [' (loc) ', repmat('|> ',1, length(x)-3)] ;
    end
    fprintf([objectNames.toolName, ':',loc , ' %s'], func_name);
%     if nargin>0
%         for i = 1:length(varargin)
%             str = varargin{i};
%             fprintf(': %s', str);
%         end
%     end
    fprintf('\n');
    
end
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%
