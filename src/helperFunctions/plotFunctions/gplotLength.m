function [d] = gplotLength(a, x, linewidth)
% function [d] = gplotLength(a, x,linewidth)
%
% plot with colors depending on lengths of
% edges in x,
% a: Adjacency
% x: coords
% linewidth: for ploting

[ai,aj] = find(a);
m = length(ai);
d = double(a);

for i = 1:m 
    d(ai(i),aj(i)) = norm(x(ai(i),:)-x(aj(i),:)); 
end

[di,dj,dv] = find(d);

sdv = sort(dv);
l = length(sdv);

ran = [64:-1:0]/64;
ran = ran.^2;
ran = 1-ran;

ll = round([1:l/65:l]);
ranges = sdv(ll);

clf; hold on;
set(gca,'Color',[0 0 0])

cm = jet;

%cm = .3+.7*cm;

for i = 1:64;
ind = (dv <= ranges(i+1))&(dv>ranges(i));

thisa = sparse(ai(ind),aj(ind),1);
[gpx,gpy] = gplot(thisa,x);
if (~isempty(gpx)),
  ph(i) = plot(gpx,gpy,'-','Color',cm(i,:),'LineWidth',linewidth);
  axis off
end

end

