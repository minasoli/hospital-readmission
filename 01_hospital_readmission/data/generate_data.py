import csv, random, datetime

random.seed(42)

diagnoses = ["Heart Failure","Pneumonia","COPD","Diabetes","Hip Fracture","Sepsis","AMI","Stroke"]
payers = ["Medicare","Medicaid","Blue Cross","Aetna","UnitedHealth","Self-Pay"]
hospitals = ["St. Mary Medical Center","Riverside General","Valley Health","Summit Hospital","Lakeside Medical"]
discharge_dispositions = ["Home","SNF","Home Health","AMA","Hospice"]

rows = []
patient_id = 1000
for _ in range(1200):
    admit = datetime.date(2023, 1, 1) + datetime.timedelta(days=random.randint(0, 364))
    los = random.randint(1, 14)
    discharge = admit + datetime.timedelta(days=los)
    age = random.randint(45, 90)
    readmit_risk = 0.15 + (0.01 * max(0, age - 65)) + (0.05 if los > 7 else 0)
    readmitted = random.random() < min(readmit_risk, 0.45)
    readmit_days = random.randint(1, 30) if readmitted else None
    rows.append({
        "patient_id": patient_id,
        "hospital": random.choice(hospitals),
        "admit_date": admit,
        "discharge_date": discharge,
        "length_of_stay": los,
        "age": age,
        "gender": random.choice(["M","F"]),
        "primary_diagnosis": random.choice(diagnoses),
        "payer": random.choice(payers),
        "discharge_disposition": random.choice(discharge_dispositions),
        "readmitted_30day": int(readmitted),
        "days_to_readmission": readmit_days,
        "attending_physician_id": f"DR{random.randint(100,150):03d}"
    })
    patient_id += 1

with open("/home/claude/projects/01_hospital_readmission/data/readmissions.csv","w",newline="") as f:
    writer = csv.DictWriter(f, fieldnames=rows[0].keys())
    writer.writeheader()
    writer.writerows(rows)

print(f"Generated {len(rows)} rows")
