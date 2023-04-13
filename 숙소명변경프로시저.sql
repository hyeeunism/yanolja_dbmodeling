-- �����̸� �Է¹޾� �ش� ���� ��å ��ȸ�ϴ� ���ν���

CREATE OR REPLACE PROCEDURE up_selPolicy
(   p_house_name VARCHAR2  ) -- �����̸� �Ķ���ͷ� ����
IS
    vpolicy_no ya_policy.policy_no%type;
    vpolicy_info ya_policy.policy_info%type;
    vpolicy_kids ya_policy.policy_kids%type;
    vpolicy_smoke ya_policy.policy_smoke%type;
    vpolicy_pet ya_policy.policy_pet%type;
    vhouse_code ya_policy.house_code%type;
    vhouse_name ya_policy.house_code%type;
    CURSOR hcur IS (   SELECT policy_no, policy_info, policy_kids, policy_smoke, policy_pet, house_name
                        FROM ya_policy p JOIN ya_house h ON p.house_code = h.house_code 
                        WHERE house_name = p_house_name);
    -- EXCEPTION;
BEGIN
        
        OPEN hcur;  
        LOOP
        FETCH hcur 
        INTO vpolicy_no, vpolicy_info, vpolicy_kids,  vpolicy_smoke,  vpolicy_pet, vhouse_name;    
        EXIT WHEN  hcur%NOTFOUND;
        dbms_output.put_line('> ' || p_house_name || ' ���� ��å ��ü���� ');
        dbms_output.put_line('---------------------------------------------------------');
        dbms_output.put_line('�ȳ�����: '|| vpolicy_info); 
        dbms_output.put_line('�Ƶ��Խ�: '|| REPLACE(REPLACE(vpolicy_kids, 'T', '����'),'F', '�Ұ�')); 
        dbms_output.put_line('�ݿ�: '||  REPLACE(REPLACE(vpolicy_smoke, 'T', '����'),'F', '�Ұ�')); 
        dbms_output.put_line('�ݷ���������: '||  REPLACE(REPLACE(vpolicy_pet, 'T', '����'),'F', '�Ұ�')); 
        dbms_output.put_line(' ');
        END LOOP;
-- EXCEPTION  
END;

-- �׽�Ʈ
EXEC up_selPolicy('īǪġ�����');
EXEC up_selPolicy('������');