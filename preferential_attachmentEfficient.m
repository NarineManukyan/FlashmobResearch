function [NetworkOverTime edges]  = preferential_attachmentEfficient(m, tmax)
% Input:       m  - # edges to attach at every step
%             tmax - # number of time steps
% Output:    NetworkOverTime - Struct that contains the edge list over tmax
%                                                     steps
%                  edges - edge list at the end
%
% Example: edges = preferential_attachmentEfficient(1,5, 1000);

vert = 2;
edges=[1 2];  % start with an edge
targets = [1 2]; % list of all targets

for t = 1:tmax
    vert=vert+1;  % add new vertex(es)
    
    if m>=vert-1
        for node=1:vert-1
            edges = [edges; vert node];
            targets = [targets node];
        end
    else
        % add m edges
        rn = rand(1,1);
        if rn < m/(m+1.5)
            % Randomly sample the vertexies proportional to their indegree without
            % replacement
            ct = 1;
            r = [];
            targetse = targets;
            while ct <= m
                re = randsample(targetse,1);
                if ~sum(r == re)
                    r(ct) = re;
                    ct = ct+1;
                    targetse(targetse == re)=[];
                end
            end
            
        else
            r = randsample(vert,m);
        end
        
        for node=1:length(r)
            edges = [edges; vert r(node)];
            targets = [targets r(node)];
        end
        
    end
    NetworkOverTime{t} = edges;
end

outDeg = [];
inDeg = [];
for v=1:vert; outDeg=[outDeg; v sum(edges(:,1)==v)]; end
for v=1:vert; inDeg=[inDeg; v sum(edges(:,2)==v)]; end


figure
for d = 1:max(inDeg(:,2))
    inDegFraction(d) = sum(inDeg(:,2)==d);
end
plot(inDegFraction./vert);
set(gca,'FontSize',15, 'FontWeight','bold');
xlabel('In-degree q');
ylabel('Fraction of vertices with in-degree q');

figure
loglog(inDegFraction./vert);
set(gca,'FontSize',15, 'FontWeight','bold');
xlabel('In-degree q');
ylabel('Fraction of vertices with in-degree q');
title('LogLog plot');

figure
hist(inDeg(:,2));
xlabel('Degree');
ylabel('# of nodes');
title('histogram');
