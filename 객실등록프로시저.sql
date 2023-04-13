
CREATE OR REPLACE PROCEDURE up_selAllhouse
IS
   CURSOR hcur IS
        SELECT house_name-- �����̸�
               , house_type -- ����Ÿ�� 
                , uf_scost(house_code) -- ����������
                , uf_dcost(house_code) -- ���������
                , uf_rate(house_code) -- �������
                , uf_revcount(house_code) -- �ı��
                , uf_photo(house_code) -- ���һ���
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
        dbms_output.put_line('> ��ü ���� ����');
        dbms_output.put_line(' ');
        
        OPEN hcur;
        LOOP
        FETCH hcur INTO vhouse_name, vhouse_type, vscost, vdcost, vavgrate, vrevcount, vphoto;
        EXIT WHEN hcur%NOTFOUND;
        
        IF vhouse_type IN ('ȣ��', '���') THEN
        dbms_output.put_line(vhouse_name);
        dbms_output.put_line('--------------------------------');
        dbms_output.put_line('���һ���: ' || vphoto);
        dbms_output.put_line('�������(' || NVL(vavgrate,0)  || ') �ı��(' || vrevcount ||')');
        dbms_output.put_line('1�ڱ��� ������: ' || vscost);
        dbms_output.put_line(' ');
        ELSIF vhouse_type IN ('����') THEN
        dbms_output.put_line(vhouse_name);
        dbms_output.put_line('--------------------------------');
        dbms_output.put_line('���һ���: ' || vphoto);
        dbms_output.put_line('�������(' || NVL(vavgrate,0) || ') �ı��(' || vrevcount ||')');
        dbms_output.put_line('1�ڱ��� ���������: ' || vdcost);
        dbms_output.put_line('1�ڱ��� ����������: ' || vscost);
        dbms_output.put_line(' ');
        END IF;
    END LOOP;    
   CLOSE hcur;
END;

-- ���ν��� ����
EXEC up_selAllhouse;

--- �ʿ��Լ� :  uf_scost , uf_dcost , uf_rate, uf_revcount, uf_photo

CREATE OR REPLACE FUNCTION uf_scost -- ����������
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

CREATE OR REPLACE FUNCTION uf_dcost -- ���������
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

CREATE OR REPLACE FUNCTION uf_rate -- �������
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

CREATE OR REPLACE FUNCTION uf_revcount -- �Ѹ����
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

CREATE OR REPLACE FUNCTION uf_photo -- ���һ���(���� �� �ϳ�)
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
        SELECT h.house_name-- �����̸�
                , uf_scost(h.house_code) -- ����������
                , uf_dcost(h.house_code) -- ���������
                , uf_rate(h.house_code) -- �������
                , uf_revcount(h.house_code) -- �ı��
        FROM ya_review r RIGHT JOIN ya_house h ON r.house_code = h.house_code
        ORDER BY h.house_code;
        
        SELECT h.house_code-- �����̸�
                , uf_scost(h.house_code) -- ����������
                , uf_dcost(h.house_code) -- ���������
                , uf_rate(h.house_code) -- �������
                , uf_revcount(h.house_code) -- �ı��
        FROM ya_review r RIGHT JOIN ya_house h ON r.house_code = h.house_code
        ORDER BY h.house_code;
        

        
        select MAX(P.PHOTO_URL)
        from ya_photo P JOIN YA_ROOM R ON P.ROOM_CODE = R.ROOM_CODE
        WHERE R.HOUSE_CODE = 'house_1';
        
        
        
        
        