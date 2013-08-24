create or replace function peak_prominence(
        g geography(point,4326),
        ele numeric)
    returns int
    language plpgsql as
$func$
declare
    local_avg_ele numeric;
    local_peak_count numeric;
    score numeric := 0;
begin
    local_avg_ele := (
        select avg(ele_int)
        from peaks
        where st_dwithin(g, geog, 10000));

    local_peak_count := (
        select count(*)
        from peaks
        where st_dwithin(g, geog, 10000));

    if ele - local_avg_ele > 500 then score := score + 50;
    elsif ele - local_avg_ele > 100 then score := score + 40;
    elsif ele - local_avg_ele > 0 then score := score + 30;
    elsif ele - local_avg_ele > -100 then score := score + 20;
    elsif ele - local_avg_ele > -500 then score := score + 10;
    end if;

    if local_peak_count < 5 then score := score * 2;
    elsif local_peak_count < 10 then score := score * 1.5;
    elsif local_peak_count < 20 then score := score * 1.25;
    elsif local_peak_count < 30 then score := score * 1.125;
    end if;

    return floor(score);
end;
$func$;
