from flask import Flask,render_template,request,session,redirect,url_for,flash,send_file
from flask_sqlalchemy import SQLAlchemy
from flask_login import UserMixin
from flask_login import logout_user,login_manager,LoginManager
from flask_login import login_required
import os

local_server= True
app = Flask(__name__)
app.secret_key='harshitha'

login_manager=LoginManager(app)
login_manager.login_view='login'

@login_manager.user_loader
def load_user(user_id):
    return Admin.query.get(int(user_id))

app.config['SQLALCHEMY_DATABASE_URI']='mysql://root:@localhost/ssmms'
app.config['UPLOAD_FOLDER'] = 'uploads'
db=SQLAlchemy(app)


class Admin(UserMixin,db.Model):
    AdminId=db.Column(db.Integer,primary_key=True)
    AdminName=db.Column(db.String(100))
    Email=db.Column(db.String(100))
    password=db.Column(db.String(1000))
    
class Student(db.Model):
    StudentId=db.Column(db.String(50),primary_key=True)
    Name=db.Column(db.String(50))
    SEmail=db.Column(db.String(50),unique=True)
    SPassword=db.Column(db.String(1000))
    Role=db.Column(db.String(50))

class Studymaterial(db.Model):
    MId=db.Column(db.Integer,primary_key=True)
    MScheme	=db.Column(db.Integer)
    MDept=db.Column(db.String(50))
    MSem=db.Column(db.Integer)
    MSub=db.Column(db.String(50))
    Module=db.Column(db.Integer)
    Material=db.Column(db.String(300))

class Questionpaper(db.Model):
    PId=db.Column(db.Integer,primary_key=True)
    PScheme	=db.Column(db.Integer)
    PDept=db.Column(db.String(50))
    PSem=db.Column(db.Integer)
    PSub=db.Column(db.String(50))
    UploadedPYQs=db.Column(db.String(300))
    
class Feedback(db.Model):
    FId = db.Column(db.Integer, primary_key=True)
    StudentId = db.Column(db.String(50), db.ForeignKey('student.StudentId'),nullable=False)
    MSub=db.Column(db.String(50))
    Module=db.Column(db.Integer)
    Rating = db.Column(db.Integer)
    Comment = db.Column(db.Text)

class Triggers(db.Model):
    tid=db.Column(db.Integer,primary_key=True)
    StudentId=db.Column(db.String(100))
    Name=db.Column(db.String(100))
    SEmail=db.Column(db.String(100))
    action=db.Column(db.String(100))
    timestamp=db.Column(db.String(100))
   
    
    
@app.route('/')
def index(): 
    return render_template('base.html')

@app.route('/admin')
def admin():
    return render_template('admin.html')

@app.route('/student')
def student(): 
    return render_template('student.html')


@app.route('/manages')
def manages():
    return render_template('manages.html')

@app.route('/studentlogin')
def studentlogin(): 
    return render_template('studentlogin.html')

@app.route('/department')
def department(): 
    return render_template('department.html')

@app.route('/login',methods=['POST','GET'])
def login():
    if request.method == "POST":
        Email=request.form.get('email')
        password=request.form.get('password')
        user=Admin.query.filter_by(Email=Email).first()
        if user and  user.password==password:
            session['username'] = user.AdminName
            return redirect(url_for('manages'))
        else:
            flash("invaild credentials","danger")
            return render_template('admin.html')
            
    return render_template('admin.html')

@app.route('/student',methods=['POST','GET'])
def addstudent():
     dept=Student.query.all()
     if request.method=="POST":
        StudentId=request.form.get('sid')
        Name=request.form.get('sname')
        SEmail=request.form.get('semail')
        SPassword=request.form.get('spassword')
        Role=request.form.get('role')
        query=Student(StudentId=StudentId,Name=Name, SEmail= SEmail,SPassword=SPassword,Role=Role)
        db.session.add(query)
        db.session.commit()

        flash("Added Successfully","info")
        return redirect('/student')
     return render_template('student.html',dept=dept)
    

@app.route('/studentdetails',methods=['POST','GET'])
def studentdetails():
    query=Student.query.all() 
    return render_template('studentdetails.html',query=query)


@app.route("/edit/<string:StudentId>",methods=['POST','GET'])
def edit(StudentId):
    if request.method=="POST":
        Name=request.form.get('sname')
        SEmail=request.form.get('semail')
        SPassword=request.form.get('spassword')
        Role=request.form.get('role')

        posts=Student.query.filter_by(StudentId=StudentId).first()
        posts.Name=Name
        posts.SEmail=SEmail
        posts.SPassword=SPassword
        posts.Role=Role
        db.session.commit()
        flash("Details is Updated","success")
        return redirect('/studentdetails')
    
    posts=Student.query.filter_by(StudentId=StudentId).first()

    return render_template('update.html',posts=posts)
    
   
@app.route("/delete/<string:StudentId>",methods=['POST','GET'])
def delete(StudentId):
    posts=Student.query.filter_by(StudentId=StudentId).first()
    db.session.delete(posts)
    db.session.commit()
    
    flash("Student Record Deleted Successfully","danger")
    return redirect('/studentdetails')

@app.route('/logout')
@login_required
def logout():
    logout_user()
    flash("Logout SuccessFul","warning")
    return redirect(url_for('login'))

@app.route('/addsm',methods=['POST','GET'])
def addstudymaterial():
    dept=Studymaterial.query.all()
    if request.method=="POST":
        MId=request.form['mid']
        MScheme=request.form['msch']
        MDept=request.form['mdep']
        MSem=request.form['msem']
        MSub=request.form['msub']
        Module=request.form['module']
        
        file = request.files['file']

        if file:
           filename = file.filename
           file_path = os.path.join(app.config['UPLOAD_FOLDER'], filename)
           file.save(file_path)

           query = Studymaterial(MId=MId, MScheme= MScheme,MDept=MDept,MSem=MSem,MSub=MSub,Module=Module, Material=file_path)
        
           db.session.add(query)
           db.session.commit()
           flash("Study Material addes successfully","success")
           return redirect('/addsm')
        else:
           return redirect('/manages')
            
    return render_template('addsm.html',dept=dept)

@app.route('/studymaterialdetails',methods=['POST','GET'])
def studymaterialdetails():
    query=Studymaterial.query.all() 
    return render_template('studymaterialdetails.html',query=query)

@app.route("/edit_studymaterial/<string:MId>",methods=['POST','GET'])
def edit_studymaterial(MId):
    if request.method=="POST":
        MScheme=request.form.get('mscheme')
        MDept=request.form.get('mdept')
        MSem=request.form.get('msem')
        MSub=request.form.get('msub')
        Module=request.form.get('module')
        Material=request.files['usm']
        if Material:
           filename = Material.filename
           file_path = os.path.join(app.config['UPLOAD_FOLDER'], filename)
           Material.save(file_path)

           posts=Studymaterial.query.filter_by(MId=MId).first()
           posts.MScheme=MScheme
           posts.MDept=MDept
           posts.MSem=MSem
           posts.MSub=MSub
           posts.Module=Module
           posts.Material=file_path
           db.session.commit()
           flash("Study Material Details is Updated","success")
        return redirect('/studymaterialdetails')
    
    posts=Studymaterial.query.filter_by(MId=MId).first()

    return render_template('updatesm.html',posts=posts)
    
   
@app.route("/delete_studymaterial/<string:MId>",methods=['POST','GET'])
def delete_studymaterial(MId):
    posts=Studymaterial.query.filter_by(MId=MId).first()
    db.session.delete(posts)
    db.session.commit()
    
    flash("Study Material Record Deleted Successfully","danger")
    return redirect('/studymaterialdetails')


@app.route('/addpyq',methods=['POST','GET'])
def addquestionpaper():
     dept=Questionpaper.query.all()
     if request.method=="POST":
        PId=request.form.get('pid')
        PScheme=request.form.get('psch')
        PDept=request.form.get('pdep')
        PSem=request.form.get('psem')
        PSub=request.form.get('psub')
        UploadedPYQs=request.files['pfile']
        if UploadedPYQs:
            filename=UploadedPYQs.filename
            file_paths=os.path.join(app.config['UPLOAD_FOLDER'],filename)
            UploadedPYQs.save(file_paths)
            
            query=Questionpaper(PId=PId, PScheme= PScheme,PDept=PDept,PSem=PSem,PSub=PSub,UploadedPYQs=file_paths)
            db.session.add(query)
            db.session.commit()
            flash( "Previous year question paper uploaded successfully","success")
            return redirect('/addpyq')
        else:
            return redirect('/manages')
     return render_template('addpyq.html',dept=dept)
 
 
@app.route('/questionpaperdetails',methods=['POST','GET'])
def questionpaperdetails():
    query=Questionpaper.query.all() 
    return render_template('questionpaperdetails.html',query=query)


@app.route("/edit_questionpaper/<string:PId>",methods=['POST','GET'])
def edit_questionpaper(PId):
    if request.method=="POST":
        PScheme=request.form.get('pscheme')
        PDept=request.form.get('pdept')
        PSem=request.form.get('psem')
        PSub=request.form.get('psub')
        UploadedPYQs=request.files['upyq']
        if UploadedPYQs:
            filename=UploadedPYQs.filename
            file_paths=os.path.join(app.config['UPLOAD_FOLDER'],filename)
            UploadedPYQs.save(file_paths)

            posts=Questionpaper.query.filter_by(PId=PId).first()
            posts.PScheme=PScheme
            posts.PDept=PDept
            posts.PSem=PSem
            posts.PSub=PSub
            posts.UploadedPYQs=file_paths
            db.session.commit()
            flash("QuestionPaper is Updated","success")
        return redirect('/questionpaperdetails')
    
    posts=Questionpaper.query.filter_by(PId=PId).first()

    return render_template('updatepyq.html',posts=posts)
    
   
@app.route("/delete_questionpaper/<string:PId>",methods=['POST','GET'])
def delete_questionpaper(PId):
    posts=Questionpaper.query.filter_by(PId=PId).first()
    db.session.delete(posts)
    db.session.commit()
    
    flash("Student Record Deleted Successfully","danger")
    return redirect('/questionpaperdetails')
 
@app.route('/signin',methods=['POST','GET'])
def signin():
    if request.method == "POST":
        SEmail=request.form.get('semail')
        SPassword=request.form.get('spassword')
        user=Student.query.filter_by(SEmail=SEmail).first()
        if user and  user.SPassword==SPassword:
            session['username'] = user.Name
            return redirect(url_for('department'))
        else:
            flash("invaild credentials","danger")
            return render_template('studentlogin.html')
            
     
    return render_template('studentlogin.html')

@app.route('/signout')
def signout():
    logout_user()
    flash("Logout SuccessFul","warning")
    return render_template('base.html')

@app.route('/triggers')
def triggers():
    # query=db.engine.execute(f"SELECT * FROM trig") 
    query=Triggers.query.all()
    return render_template('triggers.html',query=query)

@app.route('/ise')
def ise(): 
    return render_template('ise.html')

@app.route('/aiml')
def aiml(): 
    return render_template('aiml.html')

@app.route('/ece')
def ece(): 
    return render_template('ece.html')

@app.route('/eee')
def eee(): 
    return render_template('eee.html')

@app.route('/study_material')
def study_material(): 
    return render_template('study_material.html')
@app.route('/question_paper')
def question_paper(): 
    return render_template('question_paper.html')


@app.route('/get_study_material', methods=['POST'])
def get_study_material():
    MScheme = request.form['scheme']
    MDept = request.form['department']
    MSem = request.form['semester']
    MSub = request.form['subject']
    Module = request.form['module']

    material = Studymaterial.query.filter_by(MSem=MSem, MScheme=MScheme, MDept=MDept, MSub=MSub, Module=Module).first()

    if material:
        return render_template('material_view.html', material=material)
    else:
        return "Study material not found for the specified criteria"
    
@app.route('/view_material/<int:material_id>')
def view_material(material_id):
    study_material = Studymaterial.query.get(material_id)
    if study_material:
        file_path = study_material.Material  # Assuming the 'Material' column stores the file path
        return send_file(file_path, as_attachment=False)
    else:
        return 'Study material not found', 404
    
@app.route('/download_material/<int:material_id>')
def download_material(material_id):
    study_material = Studymaterial.query.get(material_id)
    if study_material:
        file_path = study_material.Material  # Assuming the 'Material' column stores the file path
        return send_file(file_path, as_attachment=True)
    else:
        return 'Study material not found', 404


@app.route('/get_question_paper', methods=['POST'])
def get_question_paper():
    PScheme = request.form['pscheme']
    PDept = request.form['pdepartment']
    PSem = request.form['psemester']
    PSub = request.form['psubject']
    paper = Questionpaper.query.filter_by(PSem=PSem, PScheme=PScheme, PDept=PDept, PSub=PSub, ).first()

    if paper:
        return render_template('qp_view.html', paper=paper)
    else:
        return "Previous Year Question Paper not found for the specified criteria"
    
@app.route('/view_questionpaper/<int:questionpaper_id>')
def view_questionpaper(questionpaper_id):
    question_paper = Questionpaper.query.get(questionpaper_id)
    if question_paper:
        file_path = question_paper.UploadedPYQs 
        return send_file(file_path, as_attachment=False)
    else:
        return 'Study material not found', 404
    
@app.route('/download_questionpaper/<int:questionpaper_id>')
def download_questionpaper(questionpaper_id):
    question_paper = Questionpaper.query.get(questionpaper_id)
    if question_paper:
        file_path = question_paper.UploadedPYQs 
        return send_file(file_path, as_attachment=True)
    else:
        return 'Study material not found', 404
    
    
@app.route('/feedback')
def feedback(): 
    return render_template('feedback.html')


@app.route('/submit_feedback', methods=['GET', 'POST'])
def submit_feedback():
    if request.method == 'POST':
        StudentId = request.form['student_id']
        MSub = request.form['sub_name']
        Module = request.form['module_num']
        Rating = request.form['rating']
        Comment = request.form['comment']
        feedback = Feedback(StudentId=StudentId,MSub=MSub, Module=Module,Rating=Rating, Comment=Comment)
        db.session.add(feedback)
        db.session.commit()
        flash("Thank for your Feedback!","success")
        return redirect('/department')
    return render_template('feedback.html')
        

@app.route('/feedbackdetails',methods=['POST','GET'])
def feedbackdetails():
    query=Feedback.query.all() 
    return render_template('feedbackdetails.html',query=query) 

  
app.run(debug=True)