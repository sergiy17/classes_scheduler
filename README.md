# Classes scheduler | Rails

A foundation for a university course scheduling system

<details>
  <summary>Project setup</summary>
                            
1. Clone the repo with `git clone https://github.com/sergiy17/classes_scheduler.git`
2. `bundle && rails db:setup && rails s`
</details>

<details>
  <summary>Requests examples and screenshots</summary>

```
GET to http://127.0.0.1:3000/students/:id/schedule_pdf
```
To view / generate the student's PDF

<img width="1722" alt="Image" src="https://github.com/user-attachments/assets/0780c2d6-b71f-4331-a163-fed6e8c0b4b1" />

```
GET to http://127.0.0.1:3000/students/:id
```

To view the detailed student info 

<img width="1119" alt="Image" src="https://github.com/user-attachments/assets/334e9202-ac8f-4b8a-93b7-a7908829574e" />

```
POST to http://127.0.0.1:3000/students/:id/add_section
```
`body: { section_id: 1 }`

To add section

<img width="1140" alt="Image" src="https://github.com/user-attachments/assets/e3338081-db6a-4dc9-8eb1-9e3679b6709e" />

```
DELETE to http://127.0.0.1:3000/students/:id/remove_section
```
`body: { section_id: 1 }`

To remove section

<img width="1166" alt="Image" src="https://github.com/user-attachments/assets/c7883663-4944-45fc-a14c-f15dd8a1a6cf" />


</details>
