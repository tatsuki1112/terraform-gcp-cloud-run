<h1>USERS</h1>

<table>
    <tr>
        <td>id</td>
        <td>name</td>
        <td>email</td>
        <td>birthday</td>
    </tr>
    @foreach ($users as $user)
    <tr>
        <td>{{$user->id}}</td>
        <td>{{$user->name}}</td>
        <td>{{$user->email}}</td>
        <td>{{$user->birthday}}</td>
    </tr>
    @endforeach

</table>

<style>
    table,
    th,
    td {
        border: 1px solid;
    }
</style>

