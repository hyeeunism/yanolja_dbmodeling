-- �����ڵ�, �ٲ� ���Ҹ� �Է¹޾� ���Ҹ� �����ϴ� ���ν���
        CREATE OR REPLACE PROCEDURE up_housename 
        (
            phouse_code ya_house.house_code%type
            ,phouse_name ya_house.house_name%type
             
        )
        IS   
            vhouse_name ya_house.house_name%type;
        BEGIN               

              UPDATE ya_house                         
                 SET house_name = phouse_name
              WHERE house_code = phouse_code;    
              
              dbms_output.put_line('>���� �̸��� ���������� ���� �Ǿ����ϴ�.' || ' �����ڵ�(' || phouse_code || ')');
              dbms_output.put_line('����� ���� �̸�: ' || phouse_name);
        -- EXCEPTION
        END;  
        
        -- �׽�Ʈ
        EXEC up_housename('house_2','��ī��ȣ��');