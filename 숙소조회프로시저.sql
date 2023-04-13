 -- �г��� �Է��Ͽ� ���� �ۼ��� �ı� ��ȸ ���ν���
 -- �ı���ȸ : �ۼ���, �������, �ı⳻��, �����̸�
 
CREATE OR REPLACE PROCEDURE up_selMyReview
(
p_user_name VARCHAR2  
) -- �г��� �Ķ���ͷ� ����
IS
    vrev_date ya_review.rev_date%type; -- �ۼ���
    vrev_avgrate NUMBER; -- ȸ�������������
    vrev_text ya_review.rev_text%type; -- �ı⳻��
    vhouse_name ya_house.house_name%type; -- �����̸�
    CURSOR hcur IS (   SELECT 
                     rev_date
                        , (rev_con + rev_kind + rev_clean + rev_locate + rev_around)/5 ���
                        , rev_text
                        , house_name
                        FROM ya_review re JOIN ya_user us ON re.user_code = us.user_code
                                          JOIN  ya_house ho ON re.house_Code = ho.house_code
                        WHERE p_user_name = user_name);
 BEGIN                         
        dbms_output.put_line('> ���� �ı� ���� ');
        dbms_output.put_line(' ');
        dbms_output.put_line(' ');
        
        OPEN hcur;  
        LOOP
        FETCH hcur 
        INTO vrev_date, vrev_avgrate, vrev_text, vhouse_name;       
        EXIT WHEN  hcur%NOTFOUND;
        dbms_output.put_line(vhouse_name);
        dbms_output.put_line('�ۼ���: ' || RPAD(vrev_date,30,' ') || '������: ' || ROUND(vrev_avgrate));  
        dbms_output.put_line('�ı⳻��: ' || vrev_text);
        dbms_output.put_line(' ');
        END LOOP;
        CLOSE hcur;
END;
-----------------------------------------------------------------------------------------------------------------------------------------------------------    
    
-- �׽�Ʈ
EXEC up_selMyReview('���ǵ���å�ڽ�'); -- user_1
EXEC up_selMyReview('���ĵ�����'); --
    