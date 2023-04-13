
CREATE OR REPLACE PROCEDURE up_selAllhouse
IS
   CURSOR hcur IS
        SELECT house_name-- 숙소이름
               , house_type -- 숙소타입 
                , uf_scost(house_code) -- 숙박최저가
                , uf_dcost(house_code) -- 대실최저가
                , uf_rate(house_code) -- 평점평균
                , uf_revcount(house_code) -- 후기수
                , uf_photo(house_code) -- 숙소사진
        FROM ya_house 
        ORDER BY house_code;
    vhouse_name ya_house.house_name%type;
    vhouse_type ya_house.house_type%type;
    vscost NUMBER;
    vdcost NUMBER;
    vavgrate  NUMBER;
    vrevcount NUMBER;
    vphoto ya_photo.photo_url%type;
BEGIN
        dbms_output.put_line('> 전체 숙소 보기');
        dbms_output.put_line(' ');
        
        OPEN hcur;
        LOOP
        FETCH hcur INTO vhouse_name, vhouse_type, vscost, vdcost, vavgrate, vrevcount, vphoto;
        EXIT WHEN hcur%NOTFOUND;
        
        IF vhouse_type IN ('호텔', '펜션') THEN
        dbms_output.put_line(vhouse_name);
        dbms_output.put_line('--------------------------------');
        dbms_output.put_line('숙소사진: ' || vphoto);
        dbms_output.put_line('평균평점(' || NVL(vavgrate,0)  || ') 후기수(' || vrevcount ||')');
        dbms_output.put_line('1박기준 최저가: ' || vscost);
        dbms_output.put_line(' ');
        ELSIF vhouse_type IN ('모텔') THEN
        dbms_output.put_line(vhouse_name);
        dbms_output.put_line('--------------------------------');
        dbms_output.put_line('숙소사진: ' || vphoto);
        dbms_output.put_line('평균평점(' || NVL(vavgrate,0) || ') 후기수(' || vrevcount ||')');
        dbms_output.put_line('1박기준 대실최저가: ' || vdcost);
        dbms_output.put_line('1박기준 숙박최저가: ' || vscost);
        dbms_output.put_line(' ');
        END IF;
    END LOOP;    
   CLOSE hcur;
END;

-- 프로시저 실행
EXEC up_selAllhouse;

--- 필요함수 :  uf_scost , uf_dcost , uf_rate, uf_revcount, uf_photo

CREATE OR REPLACE FUNCTION uf_scost -- 숙박최저가
(
  phouse_code ya_house.house_code%type
)
RETURN NUMBER
IS
  vhouse_scost ya_room.room_scost%type;
BEGIN
  SELECT MIN(r.room_scost) INTO vhouse_scost
  FROM ya_room r JOIN ya_house h ON r.house_code = h.house_code 
  WHERE h.house_code = phouse_code;
  
  RETURN ( vhouse_scost );
END;

CREATE OR REPLACE FUNCTION uf_dcost -- 대실최저가
(
  phouse_code ya_house.house_code%type
)
RETURN NUMBER
IS
  vhouse_dcost ya_room.room_dcost%type;
BEGIN
  SELECT MIN(r.room_dcost) INTO vhouse_dcost
  FROM ya_room r JOIN ya_house h ON r.house_code = h.house_code 
  WHERE h.house_code = phouse_code;
  
  RETURN ( vhouse_dcost );
END;

CREATE OR REPLACE FUNCTION uf_rate -- 평점평균
(
  phouse_code ya_house.house_code%type
)
RETURN NUMBER
IS
  vavgrate NUMBER;
BEGIN
  SELECT AVG((rev_con+rev_clean+rev_kind+rev_locate+rev_around)/5 ) INTO vavgrate
  FROM ya_review 
  WHERE house_code = phouse_code;
  
  RETURN ( vavgrate );
END;

CREATE OR REPLACE FUNCTION uf_revcount -- 총리뷰수
(
  phouse_code ya_house.house_code%type
)
RETURN NUMBER
IS
  vcount NUMBER;
BEGIN
  SELECT COUNT(*) INTO vcount
  FROM ya_review 
  WHERE house_code = phouse_code;
  
  RETURN ( vcount );
END;

CREATE OR REPLACE FUNCTION uf_photo -- 숙소사진(객실 중 하나)
(
  phouse_code ya_house.house_code%type
)
RETURN VARCHAR
IS
  vphoto ya_photo.photo_url%type;
BEGIN
  select MAX(P.PHOTO_URL) INTO vphoto
  from ya_photo P JOIN YA_ROOM R ON P.ROOM_CODE = R.ROOM_CODE
  WHERE house_code = phouse_code;
  
  RETURN ( vphoto );
END;


--------------------------------------------------------------------------------------------------------
        SELECT h.house_name-- 숙소이름
                , uf_scost(h.house_code) -- 숙박최저가
                , uf_dcost(h.house_code) -- 대실최저가
                , uf_rate(h.house_code) -- 평점평균
                , uf_revcount(h.house_code) -- 후기수
        FROM ya_review r RIGHT JOIN ya_house h ON r.house_code = h.house_code
        ORDER BY h.house_code;
        
        SELECT h.house_code-- 숙소이름
                , uf_scost(h.house_code) -- 숙박최저가
                , uf_dcost(h.house_code) -- 대실최저가
                , uf_rate(h.house_code) -- 평점평균
                , uf_revcount(h.house_code) -- 후기수
        FROM ya_review r RIGHT JOIN ya_house h ON r.house_code = h.house_code
        ORDER BY h.house_code;
        

        
        select MAX(P.PHOTO_URL)
        from ya_photo P JOIN YA_ROOM R ON P.ROOM_CODE = R.ROOM_CODE
        WHERE R.HOUSE_CODE = 'house_1';
        
        
        
        
        