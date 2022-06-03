class Person:
    def __init__(self, name:str):
        self.name = name

    def get_name(self):
        return self.name

class Student(Person):
    def __init__(self, 
                 name:str, 
                 student_number:int,
                 domain:str = "school.student.pt"):
        if student_number < 0:
            raise ValueError("Student number must be a positive number")
        self.student_number = student_number
        self.name = name

    def get_name(self):
        return f"{self.name} - {self.student_number}"