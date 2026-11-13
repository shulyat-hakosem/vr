# הסטודיו הווירטואלי של יוני

פורטל אחד לכל פרויקטי ה־VR שלנו. בדפדפן של הקווסט שומרים את הדף בסימניות פעם אחת, וכל טסט חדש מופיע כאן.

- האתר: https://shulyat-hakosem.github.io/vr/
- בלי שלב בנייה: HTML, CSS ו־`projects.json` בלבד.

## הוספת פרויקט

ערוך את [`projects.json`](projects.json) והוסף רשומה בראש הרשימה:

```json
{
  "title": "שם הפרויקט",
  "subtitle": "משפט קצר",
  "url": "https://shulyat-hakosem.github.io/…/",
  "date": "2026-11-13",
  "status": "חי",
  "thumbnail": "assets/thumbs/example.jpg"
}
```

`thumbnail` הוא שדה רשות. השדה `status` מופיע על הכרטיס כפי שהוא (למשל `חי`, `טסט`, `בעבודה`).

או הרץ את הסקריפט:

```bash
./add-project.sh \
  --title "שם הפרויקט" \
  --subtitle "משפט קצר" \
  --url "https://shulyat-hakosem.github.io/…/" \
  --date 2026-11-13 \
  --status "חי" \
  --thumbnail ./shot.jpg
```

אחר כך commit ו־push ל־`main`. GitHub Pages מתעדכן מהשורש של הענף.
