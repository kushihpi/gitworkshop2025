% Create average EVENT waveforms per channel (save as .tif)
base  = data_interpolated;
fs    = base.fsample;
nChan = numel(base.label);

trlLens = cellfun(@(x) size(x,2), base.trial);
edges   = [0, cumsum(trlLens)];

% Reconstruct per-trial events from artifact_mask
events_per_trial_ch = cell(nChan,1);
for c = 1:nChan
    m = artifact_mask(c,:);
    d = diff([0 m 0]);
    s = find(d==1); e = find(d==-1)-1;
    A = [s(:) e(:)];
    ev_c = cell(numel(trlLens),1);
    for t = 1:numel(trlLens)
        if isempty(A), ev_c{t} = zeros(0,2); continue; end
        a = max(A(:,1), edges(t)+1);
        b = min(A(:,2), edges(t+1));
        keep = (b >= a);
        ev_c{t} = [a(keep)-edges(t), b(keep)-edges(t)];
    end
    events_per_trial_ch{c} = ev_c;
end

% parameters
ctx_extra_s = 0.5; % additional non-omitted context
omit_core_s = 0.5; % omitted core to shade
pre_s  = omit_core_s + ctx_extra_s;
post_s = omit_core_s + ctx_extra_s;
preS   = round(pre_s*fs);
postS  = round(post_s*fs);
t      = (-preS:postS)/fs;

for c = 1:nChan
    waves = [];

    for tIdx = 1:numel(base.trial)
        x  = double(base.trial{tIdx}(c,:));
        ev = events_per_trial_ch{c}{tIdx};
        if isempty(ev), continue; end

        for k = 1:size(ev,1)
            segIdx = ev(k,1):ev(k,2);
            [~,loc] = max(abs(x(segIdx)));
            ctr = ev(k,1) + loc - 1;
            s0 = ctr - preS; e0 = ctr + postS;
            if s0 >= 1 && e0 <= numel(x)
                waves(end+1,:) = x(s0:e0); %#ok<AGROW>
            end
        end
    end

    if isempty(waves)
        fprintf('Channel %s: no full ±%.1fs events.\n', base.label{c}, pre_s);
        continue;
    end

    avgWave = mean(waves,1);

    % Plot
    fig = figure('Name', sprintf('Avg EVENT: %s', base.label{c}), 'Visible','off');
    h = plot(t, avgWave, 'LineWidth', 1.6); grid on; hold on
    xlabel('Time (s)'); ylabel('Amplitude (data units)');
    title(sprintf('%s — mean of %d events (±%.1f s window, shaded ±%.1f s)', ...
          base.label{c}, size(waves,1), pre_s, omit_core_s));

    yl = ylim;
    patch([-omit_core_s -omit_core_s omit_core_s omit_core_s], ...
          [yl(1) yl(2) yl(2) yl(1)], [0.87 0.87 0.87], ...
          'EdgeColor','none', 'FaceAlpha',0.45);
    uistack(h,'top');
    line([0 0], yl, 'Color',[0 0 0], 'LineStyle','--');
    hold off

%     % Save as .tif (compatible with older MATLAB versions)
%     fname = sprintf('AVG_%s.tif', strrep(base.label{c}, '-', '_'));
%     print(fig, fname, '-dtiff', '-r300'); % 300 dpi TIFF
%     close(fig);

    % fprintf('Saved: %s\n', fname);
end
