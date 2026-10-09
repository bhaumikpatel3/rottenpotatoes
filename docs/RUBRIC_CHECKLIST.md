# Final checks before Canvas submission

Run these checks on the public deployed app. Local or CI success alone does not establish deployment credit.

| Points | Criterion | Verification |
| --- | --- | --- |
| 30 | Deployed | Open the public HTTPS URL in a fresh browser session and confirm the movie page loads. |
| 5 | Create | Add a clearly named temporary test movie and confirm it is saved. |
| 5 | Read | Open that movie and check title, rating, date, and description. |
| 5 | Update | Change all four fields, save, and reopen the movie. |
| 5 | Delete | Delete the temporary test movie and confirm it disappears. |
| 5 | Deployed seeds | Confirm the initial collection includes the eight movies from `db/seeds.rb`. |
| 5 | Additional seeds | Confirm the three additions exist and two seed runs do not increase the count. |
| 10 | Table | Confirm the index uses `table`, `thead`, `th`, `tbody`, and `tfoot`; descriptions appear only on the details page. |
| 15 | Sorting | Check title, rating, and date both ascending and descending; leave the index and return after CRUD to confirm the choice persists. |
| 15 | Style | Confirm the sorted column has a direction-specific color and arrow; all four pages have handwritten styling. |

- [x] Implementation CI passes at `b6da40e`: 15 tests, 149 assertions, no failures or errors; style, security scan, and production assets pass.
- [ ] Confirm the final submitted commit is also green.
- [ ] All public-app checks above pass.
- [ ] The working deployed URL is in `README.md`, committed and pushed.
- [ ] Course staff can access the repository.
- [ ] The GitHub repository URL is submitted to Canvas by October 19 at 11:59 p.m. in the course's stated timezone.
- [ ] Hosting remains available through grading.

Only the last commit before the assignment deadline is graded according to the supplied instructions. Do not replace an acceptable on-time submission with a late one without considering the course's late policy. The copied assignment text omitted the numerical late-penalty formula; consult Canvas for the actual formula.
