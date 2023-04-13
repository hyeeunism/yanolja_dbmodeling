-- ���� ���ν���
        CREATE OR REPLACE PROCEDURE up_upRoom
        (
            phouse_code ya_room.house_code%type
            ,Phouse_type ya_house.house_type%type
            ,proom_name ya_room.room_name%type
            ,proom_min ya_room.room_min%type
            ,proom_max ya_room.room_max%type
            ,proom_scost ya_room.room_scost%type
            ,proom_dcost ya_room.room_dcost%type   
        )
        IS
            vroom_code VARCHAR2(15);
            invaild_roommax exception;
            PRAGMA EXCEPTION_INIT(invaild_roommax, -20001);
        BEGIN
            SELECT MAX(SUBSTR(room_code,6))+1 INTO vroom_code 
            FROM ya_room;
            
            IF proom_max < proom_min THEN
            raise invaild_roommax;
            END IF;
           
            INSERT INTO ya_room (room_code, room_name, room_min, room_max, room_scost, room_dcost, house_code)
                    VALUES('room_'||vroom_code, proom_name, proom_min, proom_max, proom_scost, proom_dcost, phouse_code);
                    
            IF phouse_type IN ('ȣ��', '���') THEN
                dbms_output.put_line('> ������ ���������� ��ϵǾ����ϴ�.');
                dbms_output.put_line('---------------------------------------------------------');
                dbms_output.put_line( '�����̸� : ' || proom_name);
                dbms_output.put_line( '�����ο� : ' || proom_min);
                dbms_output.put_line( '�ִ��ο� : ' || proom_max );
                dbms_output.put_line( '���ڰ��� : ' || proom_scost);
            ELSIF phouse_type IN ('����') THEN
                dbms_output.put_line('> ������ ���������� ��ϵǾ����ϴ�.');
                dbms_output.put_line('---------------------------------------------------------');
                dbms_output.put_line( '�����̸� : ' || proom_name);
                dbms_output.put_line( '�����ο� : ' || proom_min);
                dbms_output.put_line( '�ִ��ο� : ' || proom_max );
                dbms_output.put_line( '��ǰ��� : ' || proom_dcost);
                dbms_output.put_line( '���ڰ��� : ' || proom_scost);
            END IF;
            COMMIT;
        EXCEPTION
        -- �ִ��ο�<�ּ��ο�
            WHEN invaild_roommax then
            ROLLBACK;
            dbms_output.put_line('> �ִ��ο��� �����ο����� ���� �ԷµǾ����ϴ�.');
        END;
        
        -- �׽�Ʈ
        EXEC up_upRoom('house_3','���', 'ƯƯƯ��',2,1,50000, null);   -- �ִ��ο�<�ּ��ο�  
        EXEC up_upRoom('house_1','ȣ��', '��մ¹�',2,2,50000, null);  -- �ִ��ο�>�ּ��ο�
        EXEC up_upRoom('house_4','����', 'ƯƯƯ��',2,2,50000,20000); -- ������ ���
        COMMIT;
        ROLLBACK;
        
        DELETE FROM ya_room
        WHERE room_name IN( 'ƯƯƯ��', '��մ¹�');
----------------------------------------------------------------------------------------------------------------------------------------
        
        SELECT *
        FROM ya_HOUSE;
        
        SELECT *
        FROM YA_ROOM;
        