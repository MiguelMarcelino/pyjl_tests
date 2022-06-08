class Student:
    def __init__(self, name:str, student_number:int, domain:str = "school.student.pt"):
        if student_number < 0:
            raise ValueError("Student number must be a positive number")
        self.student_number = student_number
        self.name = name