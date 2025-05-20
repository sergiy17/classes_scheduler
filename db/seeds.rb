students = Student.create([
                            { name: "Alice Smith" },
                            { name: "Bob Johnson" },
                            { name: "Carol Williams" }
                          ])

teachers = Teacher.create([
                            { name: "Mr. Herbert Garrison" },
                            { name: "Dr. Jane Rodriguez" },
                            { name: "Prof. Michael Lee" }
                          ])

subjects = Subject.create([
                            { name: "Science" },
                            { name: "History" },
                            { name: "Math" }
                          ])

classrooms = Classroom.create([
                                { name: "Room 101" },
                                { name: "Room 202" },
                                { name: "Room 303" }
                              ])

sections = Section.create([
                            {
                              teacher: teachers[0], # Mr. Herbert Garrison
                              subject: subjects[0], # Science
                              classroom: classrooms[0], # Room 101
                              start_time: Time.parse("08:00"),
                              end_time: Time.parse("08:50"),
                              days: %w(Monday Wednesday Friday)
                            },
                            {
                              teacher: teachers[1], # Dr. Jane Rodriguez
                              subject: subjects[1], # History
                              classroom: classrooms[1], # Room 202
                              start_time: Time.parse("09:00"),
                              end_time: Time.parse("10:20"),
                              days: %w(Tuesday Thursday)
                            },
                            {
                              teacher: teachers[2], # Prof. Michael Lee
                              subject: subjects[2], # Math
                              classroom: classrooms[2], # Room 303
                              start_time: Time.parse("13:00"),
                              end_time: Time.parse("13:50"),
                              days: %w(Monday Tuesday Wednesday Thursday Friday)
                            }
                          ])
StudentSection.create([
                        { student: students[0], section: sections[0] }, # Alice in Science
                        { student: students[0], section: sections[1] }, # Alice in History
                        { student: students[1], section: sections[1] }, # Bob in History
                        { student: students[1], section: sections[2] }, # Bob in Math
                        { student: students[2], section: sections[0] }, # Carol in Science
                        { student: students[2], section: sections[2] }  # Carol in Math
                      ])