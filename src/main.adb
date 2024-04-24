with Ada.Text_IO; use Ada.Text_IO;
with GNAT.Semaphores; use GNAT.Semaphores;


procedure Main is
type Fork is new Counting_Semaphore(1, Default_Ceiling);
   Forks: array (1..5) of Fork;
   Table: Counting_Semaphore(4, Default_Ceiling);

   task type Philosofer is
      entry Start(Id: in Integer);
   end Philosofer;

   task body Philosofer is
      Left_Fork_Id: Integer;
      Right_Fork_Id: Integer;
      Id: Integer;
   begin
      accept Start (Id : in Integer) do
         Philosofer.Id := Id;
         Left_Fork_Id:= Id;
         Right_Fork_Id:= Id mod 5 + 1;
      end Start;
      for I in 1..5 loop
         Put_Line("Philosofer" & Id'Img & " thinking");
         Table.Seize;
         Forks(Left_Fork_Id).Seize;
         Forks(Right_Fork_Id).Seize;
         Put_Line("Philosofer" & Id'Img & " eating");
         Forks(Right_Fork_Id).Release;
         Forks(Left_Fork_Id).Release;
         Table.Release;
      end loop;
   end Philosofer;

   Philosofers : array (1..5) of Philosofer;

begin
   for I in Philosofers'Range loop
      Philosofers(I).Start(I);
   end loop;

end Main;
