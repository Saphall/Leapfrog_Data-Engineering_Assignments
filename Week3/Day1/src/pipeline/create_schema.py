import psycopg2

try:
    connection = psycopg2.connect(
        user="postgres",
        password="admin",
        host="localhost",
        port="5432",
        database="etl_day1"
    )
    
    cursor = connection.cursor()
    
    employee_dimension = '''
    CREATE TABLE IF NOT EXISTS employee_dimension(
        employee_id serial PRIMARY KEY,
        first_name VARCHAR(30) NOT NULL,
        last_name VARCHAR(30) NOT NULL,
        dob DATE,
        location VARCHAR(50),
        manager_employee_id int,
        hire_date DATE NOT NULL,
        terminated_date DATE NOT NULL,
        terminated_reaseon TEXT,
        cost_center INT NOT NULL,
        constraINT fk_manager_employee
            foreign key (manager_employee_id)
                REFERENCES employee_dimension(employee_id)
    );'''
    
    department_dimension = '''
    CREATE TABLE IF NOT EXISTS department_dimension(
        department_id serial PRIMARY KEY,
        department_name VARCHAR(50) NOT NULL
    );'''
    
    employee_role_dimension = '''
    CREATE TABLE IF NOT EXISTS employee_role_dimension(
        role_id serial PRIMARY KEY,
        employee_role VARCHAR(50) NOT NULL
    );'''
    
   
    punch_dimension = '''
    CREATE TABLE IF NOT EXISTS punch_dimension(
        punch_id serial PRIMARY KEY ,
        year INT NOT NULL,
        month INT NOT NULL,
        day INT NOT NULL,
        week INT  NOT NULL,
        week_day VARCHAR(8) NOT NULL
    );'''
    
    
    paycode_dimension = '''
    CREATE TABLE IF NOT EXISTS paycode_dimension(
        paycode_id serial PRIMARY KEY,
        paycode VARCHAR(10) NOT NULL
    );'''
    
    
    shift_dimension = '''
    CREATE TABLE IF NOT EXISTS shift_dimension(
        shift_id serial PRIMARY KEY ,
        shift_type VARCHAR(10) NOT NULL,
        shift_start_time TIMESTAMP NOT NULL,
        shift_end_time TIMESTAMP NOT NULL
    );'''
    
    
    employee_work_fact = '''
    CREATE  TABLE IF NOT EXISTS employee_work_fact (
        employee_id INT REFERENCES employee_dimension(employee_id),
        department_id INT REFERENCES department_dimension(department_id),
        role_id INT REFERENCES employee_role_dimension(role_id),
        punch_id INT REFERENCES punch_dimension(punch_id),
        shift_id INT REFERENCES shift_dimension(shift_id),
        paycode_id INT REFERENCES paycode_dimension(paycode_id),
        punch_in_time TIMESTAMP ,
        punch_out_time TIMESTAMP,
        hours_worked TIMESTAMP,
        fte float ,
        salary int
    );'''
    
        
    cursor.execute(employee_dimension)
    cursor.execute(department_dimension)
    cursor.execute(employee_role_dimension)
    cursor.execute(punch_dimension)
    cursor.execute(paycode_dimension)
    cursor.execute(shift_dimension)
    cursor.execute(employee_work_fact)
    
    connection.commit()
    
except Exception as e:
    print("[-] Exception Occurred:", e)

finally:
    cursor.execute("SELECT version();")
    print(cursor.fetchone())
    print("[+] Executed !")
    cursor.close()
    connection.close()
    print("[+] Connection Closed !")
