function ret= plc_z_code_helper(op, a1, a2)
%
% Convert indexes into PLC physical addresses (memory, input, output).
% Memory is used to represent Petri net transitions and places.

% IST 2015, JG

global zCodeConfig

if nargin<1
    op= 'config_get';
end
if ~isempty(zCodeConfig)
    zCode= plc_z_code_helper_config();
end

switch op
    case 'config'
        % choose the hardware to output code for
        if nargin>=2
            zCodeConfig= a1;
        else
            zCodeConfig= plc_z_code_helper_config_questdlg;
        end
        ret= plc_z_code_helper_config();

    case 'config_get'
        % get current hardware configuration
        if ~isempty(zCodeConfig)
            ret= zCode; % return current info
        else
            ret= plc_z_code_helper('config'); % ask info to the user
        end
        
    case 'name_trans'
        % Petri net transitions t1..t99 (t0 can be a reset transition)
        error_if_not_in_range(a1, 0, 99);
        ret= ['%MW' sprintf('%d', 100+a1)];
        
    case 'name_place'
        % Petri net places p1..p99 (p0 usually not used)
        error_if_not_in_range(a1, 0, 99);
        ret= ['%MW' sprintf('%d', 200+a1)];
        
    case 'name_inp',
        % PLC input can be %i0.3.0 .. %i0.3.15
        error_if_not_in_range(a1, zCode.inpMin, zCode.inpMax);
        ret= [zCode.inp sprintf('%d', a1)];
        
    case 'name_outp',
        % PLC output can be %i0.3.16 .. %i0.3.27
        error_if_not_in_range(a1, zCode.outpMin, zCode.outpMax);
        ret= [zCode.outp sprintf('%d', a1)];
        
    case 'report'
        % tell things to do e.g. in Unity
        error('not implemented yet')
        
    otherwise
        error('Invalid input arg "op"');
end


function error_if_not_in_range(a1, a1_min, a1_max)
if a1<a1_min || a1_max<a1
    error(['Value ' num2str(a1) ' is outside valid range ' ...
        num2str(a1_min) '..' num2str(a1_max) ' .']);
end


function zCode= plc_z_code_helper_config()
global zCodeConfig

switch zCodeConfig
    case 's3_DMY28FK'
        zCode= struct(...
            'inp','%i0.3.','inpMin',0,'inpMax',15, ...
            'outp','%q0.3.','outpMin',16,'outpMax',27 ...
            );
    case 's2_DEY16D2_s4_DSY16T2'
        zCode= struct(...
            'inp','%i0.2.','inpMin',0,'inpMax',15, ...
            'outp','%q0.4.','outpMin',0,'outpMax',15 ...
            );
    otherwise
        error('invalid zCodeConfig global string')
end


function hwInfo= plc_z_code_helper_config_questdlg
hwInfo= questdlg('Select hardware','PLC config', ...
    's2_DEY16D2_s4_DSY16T2', 's3_DMY28FK', 's3_DMY28FK');
