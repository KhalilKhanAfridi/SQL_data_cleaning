CREATE TABLE public.laptop (
    index INTEGER,
    Company TEXT,
    TypeName TEXT,
    Inches TEXT,
    ScreenResolution TEXT,
    Cpu TEXT,
    Ram TEXT,
    Memory TEXT,
    Gpu TEXT,
    OpSys TEXT,
    Weight TEXT,
    Price TEXT
);
COPY public.laptop
FROM 'C:\\laptopData.csv'
DELIMITER ','
CSV HEADER;

select * from laptop

alter table laptop drop column "id"

DELETE FROM laptop
WHERE company IS NULL
  AND typename IS NULL
  AND inches IS NULL
  AND screenresolution IS NULL
  AND cpu IS NULL
  AND ram IS NULL
  AND memory IS NULL
  AND gpu IS NULL
  AND opsys IS NULL
  AND weight IS NULL
  AND price IS NULL;




SELECT 
    company,
    typename,
    inches,
    screenresolution,
    cpu,
    ram,
    memory,
    gpu,
    opsys,
    weight,
    price,
    COUNT(*) AS duplicate_count
FROM laptop
GROUP BY 
    company,
    typename,
    inches,
    screenresolution,
    cpu,
    ram,
    memory,
    gpu,
    opsys,
    weight,
    price
HAVING COUNT(*) > 1;





DELETE FROM laptop a
USING laptop b
WHERE a.ctid < b.ctid
AND a.company IS NOT DISTINCT FROM b.company
AND a.typename IS NOT DISTINCT FROM b.typename
AND a.inches IS NOT DISTINCT FROM b.inches
AND a.screenresolution IS NOT DISTINCT FROM b.screenresolution
AND a.cpu IS NOT DISTINCT FROM b.cpu
AND a.ram IS NOT DISTINCT FROM b.ram
AND a.memory IS NOT DISTINCT FROM b.memory
AND a.gpu IS NOT DISTINCT FROM b.gpu
AND a.opsys IS NOT DISTINCT FROM b.opsys
AND a.weight IS NOT DISTINCT FROM b.weight
AND a.price IS NOT DISTINCT FROM b.price;



UPDATE laptop
SET inches = NULL
WHERE inches = '?' OR inches = '';


ALTER TABLE laptop
ALTER COLUMN inches TYPE NUMERIC(10,1)
USING inches::NUMERIC(10,1);


UPDATE laptop
SET ram = REPLACE(ram, 'GB', '');

ALTER TABLE laptop
ALTER COLUMN ram TYPE INTEGER
USING ram::integer;


UPDATE laptop
SET weight = REPLACE(weight, 'kg', '');


ALTER TABLE laptop
ALTER COLUMN weight TYPE NUMERIC
USING NULLIF(TRIM(weight), '?')::numeric;


ALTER TABLE laptop
ALTER COLUMN price TYPE NUMERIC
USING ROUND(price::numeric);

select * from laptop


update laptop set opsys  = 
case when opsys like '%Mac%' then 'macos'
when opsys like 'Windows%' then 'windows'
when opsys like '%Linux%' then 'linux'
when opsys like '%No OS%' then 'N/A'
else 'other'
end


select * from laptop

ALTER TABLE laptop
ADD COLUMN gpu_brand VARCHAR(255),
ADD COLUMN gpu_name VARCHAR(255);

UPDATE laptop
SET gpu_brand = SPLIT_PART(gpu, ' ', 1);


UPDATE laptop
SET gpu_name = TRIM(SUBSTRING(gpu FROM POSITION(' ' IN gpu)));

ALTER TABLE laptop
DROP COLUMN gpu;


ALTER TABLE laptop
ADD COLUMN cpu_brand VARCHAR(255),
ADD COLUMN cpu_name VARCHAR(255),
ADD COLUMN cpu_speed DECIMAL(10,1);


select * from laptop


UPDATE laptop
SET gpu_brand = SPLIT_PART(gpu, ' ', 1);



UPDATE laptop
SET cpu_brand = SPLIT_PART(cpu, ' ', 1



UPDATE laptop
SET cpu_speed = CAST(
    REPLACE(
        SPLIT_PART(cpu, ' ', array_length(string_to_array(cpu, ' '), 1)),
        'GHz',
        ''
    ) AS REAL
);



UPDATE laptop
SET cpu_name = LOWER(
    TRIM(
        REGEXP_REPLACE(
            REGEXP_REPLACE(cpu, '^(Intel|AMD)\s+', ''),
            '\s[0-9]+(\.[0-9]+)?GHz$',
            ''
        )
    )
);


ALTER TABLE laptop
DROP COLUMN cpu;


select * from laptop


ALTER TABLE laptop
ADD COLUMN res_wid INTEGER,
ADD COLUMN res_height INTEGER;

UPDATE laptop
SET res_wid = SPLIT_PART(SPLIT_PART(screenresolution, ' ', array_length(string_to_array(screenresolution, ' '), 1)), 'x', 1)::INTEGER,
    res_height = SPLIT_PART(SPLIT_PART(screenresolution, ' ', array_length(string_to_array(screenresolution, ' '), 1)), 'x', 2)::INTEGER;


ALTER TABLE laptop
ADD COLUMN touch_screen INTEGER


UPDATE laptop
SET touch_screen = CASE
    WHEN screenresolution LIKE '%Touch%' THEN 1
    ELSE 0
END;


select * from laptop


ALTER TABLE laptop
DROP COLUMN screenresolution;


UPDATE laptop
SET cpu_name = (
    SELECT string_agg(word, ' ')
    FROM (
        SELECT unnest(string_to_array(cpu_name, ' ')) AS word
        LIMIT 2
    ) t
);


ALTER TABLE laptop
ADD COLUMN memory_type VARCHAR(255),
ADD COLUMN primary_storage INTEGER,
ADD COLUMN secondary_storage INTEGER;

update laptop set memory_type = 
case when memory like '%SSD%' and memory like '%HDD%' then 'hybrid'
when memory like '%SSD%' then 'SSD'
when memory like '%HDD%' then 'HDD'
when memory like '%Flash Storage%' then 'Flash Storage'
when memory like '%Hybrid%' then 'hybrid'
when memory like '%Flash Storage%' and memory like '%HDD%' then 'hybrid'
else null 
end;

select * from laptop

UPDATE laptop
SET primary_storage =
    (SUBSTRING(SPLIT_PART(memory, '+', 1) FROM '[0-9]+'))::INTEGER;


UPDATE laptop
SET secondary_storage = CASE
    WHEN memory LIKE '%+%' THEN
        (SUBSTRING(SPLIT_PART(memory, '+', 2) FROM '[0-9]+'))::INTEGER
    ELSE 0
END;


update laptop set primary_storage = 
case when primary_storage <=2 then primary_storage*1024 else primary_storage end,
secondary_storage =
case when secondary_storage <=2 then secondary_storage*1024 else secondary_storage end;

ALTER TABLE laptop
DROP COLUMN memory;

























































































































































































