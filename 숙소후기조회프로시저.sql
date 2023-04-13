-- �����ڵ� �Է¹޾� ������å �����ϴ� ���ν���
        CREATE OR REPLACE PROCEDURE up_uppolicy
        (
            phouse_code ya_house.house_code%type   
            , ppolicy_info ya_policy.policy_info%type
            , ppolicy_kids ya_policy.policy_kids%type
            , ppolicy_smoke ya_policy.policy_smoke%type
            , ppolicy_pet ya_policy.policy_pet%type
        )
        IS   
            vhouse_code ya_policy.house_code%type;
            invaild_type exception;
            PRAGMA EXCEPTION_INIT(invaild_type, -29991);
        BEGIN               
              IF ppolicy_kids NOT IN ('T', 'F') OR ppolicy_smoke NOT IN ('T', 'F') OR ppolicy_pet NOT IN ('T', 'F') THEN
              RAISE invaild_type;
              ELSE
              UPDATE ya_policy                        
              SET policy_info = ppolicy_info,
                  policy_kids = ppolicy_kids,
                  policy_smoke = ppolicy_smoke,
                  policy_pet = ppolicy_pet
              WHERE house_code = phouse_code;
              dbms_output.put_line('> ���� �ȳ����� ���� �Ϸ�' || LPAD('�����ڵ�: ',20) || phouse_code);
              END IF;
        EXCEPTION
        -- T,F �� �ƴ� �ٸ� �� �Է����� ���
            WHEN invaild_type then
            ROLLBACK;
            dbms_output.put_line('> �߸��� ���� �ԷµǾ����ϴ�. T, F���� �Է����ּ���.');
        END;  
        
        -- �׽�Ʈ
        EXEC up_uppolicy('�Ƶ��ԽǺҰ���/������/�ݷ������Ұ���','F','T','F');
        EXEC up_uppolicy('house_3','�Ƶ��Խǰ���/������/�ݷ���������','B','T','T'); -- �Է� ����